defmodule TimeManager.Groups do
  @moduledoc """
  The Groups context.
  """

  import Ecto.Query, warn: false
  alias TimeManager.Repo

  alias TimeManager.Groups.Group
  alias TimeManager.Groups.Group_managers
  alias TimeManager.Groups.Group_users
  alias TimeManager.Accounts
  alias TimeManager.Accounts.User

  @doc """
  Returns the list of groups.

  ## Examples

      iex> list_groups()
      [%Group{}, ...]

  """
  def list_groups do
    groups =
      from(g in Group,
        select: %{id: g.id, name: g.name},
      )
      |> Repo.all()

    groups_with_user_count =
      Enum.map(groups, fn group ->
        employee_count = count_users(group.id)
        manager_count = count_managers(group.id)

        users = employee_count + manager_count

        %{group: group, users: users}
      end)
  end

  defp count_managers(group_id) do
    Group_managers
    |> where([gm], gm.group_id == ^group_id)
    |> select([gm], count(gm.id))
    |> Repo.one()
  end

  defp count_users(group_id) do
    Group_users
    |> where([gu], gu.group_id == ^group_id)
    |> select([gu], count(gu.id))
    |> Repo.one()
  end

  @doc """
  Gets a single group.

  Raises `Ecto.NoResultsError` if the Group does not exist.

  ## Examples

      iex> get_group!(123)
      %Group{}

      iex> get_group!(456)
      ** (Ecto.NoResultsError)

  """
  def get_group_and_user(id) do
    group = Repo.get(Group, id)

    case group do
      nil ->
        nil
      _ ->
        query_managers =
          from(g in Group_managers,
            where: g.group_id == ^id
          )
        query_with_preload_managers = Ecto.Query.preload(query_managers, :user)
        managers = Repo.all(query_with_preload_managers)


        query_employees =
          from(g in Group_users,
            where: g.group_id == ^id
          )
        query_with_preload_employees = Ecto.Query.preload(query_employees, :user)
        employees = Repo.all(query_with_preload_employees)

        %{users: managers ++ employees, group: group}
    end

  end

  def get_group(id), do: Repo.get(Group, id)


  @doc """
  Creates a group.

  ## Examples

      iex> create_group(%{field: value})
      {:ok, %Group{}}

      iex> create_group(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_group(attrs \\ %{}) do
    %Group{}
    |> Group.register_group(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a group.

  ## Examples

      iex> update_group(group, %{field: new_value})
      {:ok, %Group{}}

      iex> update_group(group, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_group(%Group{} = group, attrs) do
    group
    |> Group.changeset_update(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a group.

  ## Examples

      iex> delete_group(group)
      {:ok, %Group{}}

      iex> delete_group(group)
      {:error, %Ecto.Changeset{}}

  """
  def delete_group(%Group{} = group) do
    Repo.delete(group)
  end

  def remove_user_from_group_id(%User{} = user, group_id) do
    cond do
      user.role == :MANAGER ->
        line = Repo.get_by(Group_managers, user_id: user.id)
        Accounts.remove_group_id_for_one_user(user)
        Repo.delete(line)

      user.role == :EMPLOYEE ->
        line = Repo.get_by(Group_users, user_id: user.id)
        Accounts.remove_group_id_for_one_user(user)
        Repo.delete(line)

    end
  end
end
