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

  # Function used by ["MANAGER", "SUPER_MANAGER"] for update user
  def update(conn, %{"id" => id, "user" => user_params}) do
    {:ok, agent} = Agent.start_link(fn -> {true} end)
    active_manager = conn.assigns[:current_user]
    user = Accounts.get_user!(id)

    case {Enum.member?(active_manager.role, :SUPER_MANAGER), Enum.member?(active_manager.role, :MANAGER)} do
      {true, _} ->
        if Enum.member?(user.role, :SUPER_MANAGER) do
          Agent.update(agent, fn {value} -> {false} end)
        end
        {_, true} ->
          if !(Enum.member?(user.role, :EMPLOYEE)) || user.group_id != active_manager.group_id do
          Agent.update(agent, fn {value} -> {false} end)
        end
      end

      if Agent.get(agent, fn {value} -> value end) do
        with {:ok, %User{} = user} <- Accounts.update_user(user, user_params) do
          render(conn, "show.json", user: user)
        end
      else
        send_resp(conn, :forbidden, "Vous ne pouvez pas update cet utilisateur")
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

  def check_auth(conn, _params) do
    if user = conn.assigns[:current_user] do
      render(conn, "show.json", user: user)
    else
      conn
      |> put_status(:unauthorized)
      |> json(%{error: "Not authenticated"})
    end
  end

  def log_out(conn, _params) do
    if user = conn.assigns[:current_user] do
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
