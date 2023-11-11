defmodule TimeManagerWeb.UserJSON do
  alias TimeManager.Accounts.User

  @doc """
  Renders a list of users.
  """
  def index(%{users: users}) do
    %{data: for(user <- users, do: data_with_group_id(user))}
  end

  @doc """
  Renders a single user.
  """
  def show(%{user: user}) do
    %{data: data(user)}
  end

  defp data(%User{} = user) do
    %{
      id: user.id,
      email: user.email,
      username: user.username,
      role: user.role
    }
  end

  defp data_with_group_id(%User{} = user) do
    %{
      id: user.id,
      email: user.email,
      username: user.username,
      role: user.role,
      group_id: user.group_id
    }
  end
end
