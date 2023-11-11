defmodule TimeManagerWeb.GroupJSON do
  alias TimeManager.Groups.Group
  alias TimeManager.Accounts.User


  @doc """
  Renders a list of groups.
  """
  def index(%{groups: groups}) do
    %{data: for(group <- groups, do: data_with_count_user(group))}
  end

  @doc """
  Renders a single group.
  """
  def show(%{group: group}) do
    %{data: data(group)}
  end

  @doc """
  Renders a single group.
  """
  def show_group_and_user(%{group_and_user: group_and_user}) do
    %{data:
        %{
          group: data(group_and_user.group),
          users: for(user <- group_and_user.users, do: user_data(user.user))
        }
    }
  end

  defp data(%Group{} = group) do
    %{
      id: group.id,
      name: group.name,
    }
  end

  defp user_data(%User{} = user) do
    %{
      id: user.id,
      username: user.username,
      email: user.email,
      role: user.role,
      group_id: user.group_id,
    }
  end

  defp data_with_count_user(data) do
    %{
      id: data.group.id,
      name: data.group.name,
      count_users: data.users
    }
  end
end
