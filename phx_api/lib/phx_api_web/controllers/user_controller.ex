defmodule TimeManagerWeb.UserController do
  use TimeManagerWeb, :controller

  alias TimeManager.Accounts
  alias TimeManager.Accounts.User

  action_fallback TimeManagerWeb.FallbackController

  def index(conn, _params) do
    data = conn.query_params
    IO.inspect(data)

    username = Map.get(data, "username", "")
    email = Map.get(data, "email", "")
    IO.inspect(username)
    IO.inspect(email)

    users = Accounts.list_users(username, email)
    render(conn, "index.json", users: users)
  end

  def create(conn, %{"user" => user_params}) do
    with {:ok, %User{} = user} <- Accounts.register_user(user_params) do
      conn
      |> put_status(:created)
      |> render("show.json", user: user)
    end
  end

  def show(conn, %{"id" => id}) do
    user = Accounts.get_user!(id)
    render(conn, "show.json", user: user)
  end

  def update_me(conn, %{"user" => user_params}) do
    active_user_id = conn.assigns[:current_user].id
    user = Accounts.get_user!(active_user_id)

    with {:ok, %User{} = user} <- Accounts.update_me_user(user, user_params) do
      render(conn, "show.json", user: user)
    end
  end

  # Function used by ["MANAGER", "SUPER MANAGER"] for update user
  def update(conn, %{"id" => id, "user" => user_params}) do
    error_message = ""
    active_manager = conn.assigns[:current_user]
    user = Accounts.get_user!(id)

    case {Enum.member?(active_manager.roles, "SUPER MANAGER"), Enum.member?(active_manager.roles, "MANAGER")} do
      {true, _} ->
        if Enum.member?(user.roles, "SUPER MANAGER") do
          IO.inspect("je passe bien la")
          error_message = "Cet utilisateur ne fait pas partie de votre groupe"
        end
      {_, true} ->
        if !(Enum.member?(user.roles, "EMPLOYEE")) || user.group_id != active_manager.group_id do
          error_message = "Cet utilisateur ne fait pas partie de votre groupe"
        else
          user_params = Map.update!(user_params, :roles, ["EMPLOYEE"], fn _ -> ["EMPLOYEE"] end)
          user_params = Map.update!(user_params, :group_id, active_manager.group_id, fn _ -> active_manager.group_id end)
        end
      end
      IO.inspect(error_message)
      if error_message == "" do
        with {:ok, %User{} = user} <- Accounts.update_user(user, user_params) do
          render(conn, "show.json", user: user)
        end
      else
        conn
        |> put_status(:forbidden)
        |> json(%{error: error_message})
        |> halt()
      end
  end

  def password_update(conn, %{"id" => id, "user" => user_params}) do
    user = Accounts.get_user!(id)

    with {:ok, %User{} = user} <- Accounts.update_user_password(user, user_params) do
      render(conn, "show.json", user: user)
    end
  end

  def delete(conn, %{"id" => id}) do
    user = Accounts.get_user!(id)

    with {:ok, %User{}} <- Accounts.delete_user(user) do
      send_resp(conn, :no_content, "")
    end
  end

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
end
