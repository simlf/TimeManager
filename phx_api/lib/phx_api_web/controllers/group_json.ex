defmodule TimeManagerWeb.GroupJSON do
  alias TimeManager.Groups.Group

  @doc """
  Renders a list of groups.
  """
  def index(%{groups: groups}) do
    %{data: for(group <- groups, do: data(group))}
  end

  @doc """
  Renders a single group.
  """
  def show(%{group: group}) do
    %{data: data(group)}
  end

  defp data(%Group{} = group) do
    %{
      id: group.id,
      name: group.name,
      manager_id: group.manager_id,
      users_id: group.users_id
    }
  end
end
