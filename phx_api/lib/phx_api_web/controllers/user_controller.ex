defmodule TimeManagerWeb.UserController do
  use TimeManagerWeb, :controller

  alias TimeManager.Accounts
  alias TimeManager.Accounts.User
  alias TimeManagerWeb.GroupController
  alias TimeManager.Clocks

  action_fallback(TimeManagerWeb.FallbackController)

  # Function used for get all users (only SM)
  def index(conn, _params) do
    data = conn.query_params

    username = Map.get(data, "username", "")
    email = Map.get(data, "email", "")

    users = Accounts.list_users(username, email)
    render(conn, "index.json", users: users)
  end

  # Function used for get all employees without group (only M)
  def index_for_manager(conn, _params) do
    users = Accounts.list_users_for_manager()
    render(conn, "index.json", users: users)
  end

  # Allow for SM\M to create users
  def create(conn, %{"user" => user_params}) do
    current_user = conn.assigns[:current_user]

    # Get group_id :
    # -> same as current_user.group_id if current_user.role :MANAGER
    # -> nil or value inside user_params if current_user.role :SUPER_MANAGER
    group_id =
      cond do
        current_user.role == :MANAGER && current_user.group_id != nil ->
          current_user.group_id

        current_user.role == :MANAGER && current_user.group_id == nil ->
          conn
          |> put_status(:bad_request)
          |> json(%{error: "You're in any group"})
          |> halt()

        true ->
          id = Map.get(user_params, "group_id", nil)

          if id != nil do
            Map.delete(user_params, "group_id")
            id
          else
            nil
          end
      end

    with {:ok, %User{} = user} <- Accounts.register_user(user_params) do
      created_user = Accounts.get_user!(user.id)

      # If group_id, insert it to relation table and update user with it
      if group_id != nil do
        case created_user.role do
          :EMPLOYEE ->
            GroupController.insert_employees([created_user.id], group_id)

          :MANAGER ->
            GroupController.insert_managers([created_user.id], group_id)
        end
      end

      Clocks.create_clock(%{user_id: user.id})

      conn
      |> put_status(:created)
      |> render("show.json", user: created_user)
    end
  end

  # Show one user with his id (M can only see member of his group)
  def show(conn, %{"id" => id}) do
    user = Accounts.get_user!(id)
    active_user = conn.assigns[:current_user]

    if active_user.role == :MANAGER && user.group_id != active_user.group_id do
      conn
      |> put_status(:not_found)
      |> json(%{error: "The user is not in your group"})
      |> halt()
    end

    render(conn, "show.json", user: user)
  end

  # Function used for update himself if connected
  def update_me(conn, %{"user" => user_params}) do
    # No need to add more error management (Middleware send error if no current_user)
    active_user_id = conn.assigns[:current_user].id
    user = Accounts.get_user!(active_user_id)

    with {:ok, %User{} = user} <- Accounts.update_me_user(user, user_params) do
      render(conn, "show.json", user: user)
    end
  end

  # Function used by ["MANAGER", "SUPER_MANAGER"] for update user (No possibilities to update group_id here)
  def update(conn, %{"id" => id, "user" => user_params}) do
    active_manager = conn.assigns[:current_user]
    user = Accounts.get_user!(id)

    check =
    case {active_manager.role == :SUPER_MANAGER, active_manager.role == :MANAGER} do
      {true, _} ->
        if user.role == :SUPER_MANAGER do
          false
        else
          true
        end

      {_, true} ->
        if user.role != :EMPLOYEE || user.group_id != active_manager.group_id do
          false
        else
          true
        end
    end

    if check do
      with {:ok, %User{} = updated_user} <- Accounts.update_user(user, user_params) do
        # If user have group and his role is updated, need to update relation table
        if updated_user.group_id && updated_user.role != user.role do
          GroupController.change_user_relation_table(updated_user)
        end

        render(conn, "show.json", user: updated_user)
      end
    else
      conn
      |> put_status(:forbidden)
      |> json(%{error: "You can't update this user"})
      |> halt()
    end
  end

  # Function used for update the password of connected user
  def password_update(conn, %{"id" => id, "user" => user_params}) do
    user = Accounts.get_user!(id)

    with {:ok, %User{} = user} <- Accounts.update_user_password(user, user_params) do
      render(conn, "show.json", user: user)
    end
  end

  # Function used for delete one user
  def delete(conn, %{"id" => id}) do
    user = Accounts.get_user!(id)

    case user.role do
      :SUPER_MANAGER ->
        conn
        |> put_status(:forbidden)
        |> json(%{error: "You can't delete a SUPER_MANAGER"})
        |> halt()

      _ ->
        with {:ok, %User{}} <- Accounts.delete_user(user) do
          send_resp(conn, :no_content, "")
        end
    end
  end

  # Function used for connect user and create session cookie if success
  def connection(conn, %{"user" => user_params}) do
    %{"email" => email, "password" => password} = user_params

    if user = Accounts.get_user_by_email_and_password(email, password) do
      conn
      |> TimeManager.UserAuth.log_in_user(user, user_params)
      |> json(%{message: "Logged in successfully"})
    else
      # In order to prevent user enumeration attacks, don't disclose whether the email is registered.
      render(conn, :new, error_message: "Invalid email or password")
    end
  end

  # Function used for check if user is auth and get information about him
  def check_auth(conn, _params) do
    if user = conn.assigns[:current_user] do
      render(conn, "show_auth.json", user: user)
    else
      conn
      |> put_status(:unauthorized)
      |> json(%{error: "Not authenticated"})
    end
  end

  # Function used for disconnect the user
  def log_out(conn, _params) do
    active_user = conn.assigns[:current_user]
    if active_user do
      conn = TimeManager.UserAuth.log_out_user(conn)

      conn
      |> put_status(:ok)
      |> json(%{message: "Logged out successfully"})
    else
      conn
      |> put_status(:unauthorized)
      |> json(%{error: "Not authenticated"})
    end
  end
end
