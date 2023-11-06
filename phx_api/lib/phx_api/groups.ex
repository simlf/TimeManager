defmodule TimeManager.Groups do
  @moduledoc """
  The Groups context.
  """

  import Ecto.Query, warn: false
  alias TimeManager.Repo

  alias TimeManager.Groups.Group
  alias TimeManager.Groups.Group_managers
  alias TimeManager.Groups.Group_users

  @doc """
  Returns the list of groups.

  ## Examples

      iex> list_groups()
      [%Group{}, ...]

  """
  def list_groups do
    Repo.all(Group)
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
  def get_group!(id) do
    group = Repo.get!(Group, id)

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
    |> Group.update_group(attrs)
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
end
