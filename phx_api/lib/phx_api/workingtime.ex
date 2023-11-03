defmodule TimeManager.Workingtime do
  @moduledoc """
  The Workingtime context.
  """

  import Ecto.Query, warn: false
  alias TimeManager.Repo
  alias TimeManager.Workingtime.Workingtimes

  @doc """
  Returns the list of workingtimes.

  ## Examples

      iex> list_workingtimes()
      [%Workingtimes{}, ...]

  """
  def list_workingtimes do
    Repo.all(Workingtimes)
  end

  @doc """
  Gets a single workingtimes.

  Raises `Ecto.NoResultsError` if the Workingtimes does not exist.

  ## Examples

      iex> get_workingtimes!(123)
      %Workingtimes{}

      iex> get_workingtimes!(456)
      ** (Ecto.NoResultsError)

  """
  def get_workingtimes!(id), do: Repo.get!(Workingtimes, id)

  @doc """
  Creates a workingtimes.

  ## Examples

      iex> create_workingtimes(%{field: value})
      {:ok, %Workingtimes{}}

      iex> create_workingtimes(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_workingtimes(attrs \\ %{}) do
    %Workingtimes{}
    |> Workingtimes.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a workingtimes.

  ## Examples

      iex> update_workingtimes(workingtimes, %{field: new_value})
      {:ok, %Workingtimes{}}

      iex> update_workingtimes(workingtimes, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_workingtimes(%Workingtimes{} = workingtimes, attrs) do
    workingtimes
    |> Workingtimes.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a workingtimes.

  ## Examples

      iex> delete_workingtimes(workingtimes)
      {:ok, %Workingtimes{}}

      iex> delete_workingtimes(workingtimes)
      {:error, %Ecto.Changeset{}}

  """
  def delete_workingtimes(%Workingtimes{} = workingtimes) do
    Repo.delete(workingtimes)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking workingtimes changes.

  ## Examples

      iex> change_workingtimes(workingtimes)
      %Ecto.Changeset{data: %Workingtimes{}}

  """
  def change_workingtimes(%Workingtimes{} = workingtimes, attrs \\ %{}) do
    Workingtimes.changeset(workingtimes, attrs)
  end

  def list_workingtimes_filtered(user_id, start_time, end_time)
      when is_binary(user_id) and is_binary(start_time) and is_binary(end_time) do
    query =
      from(w in Workingtimes,
        where:
          w.user_id == ^user_id and
            w.start_time >= ^start_time and
            w.end_time <= ^end_time,
        order_by: [desc: w.start_time],
        select: w
      )

    query_with_preload = Ecto.Query.preload(query, :user)
    workingtimes = Repo.all(query_with_preload)
    workingtimes
  end

def get_last_or_create_workingtime(user_id) when is_binary(user_id) do
  # Chercher le dernier working time existant pour l'utilisateur
  last_workingtime =
    from(w in Workingtimes,
      where: w.user_id == ^user_id,
      order_by: [desc: w.start_time],
      select: w,
      limit: 1
    )
    |> Ecto.Query.preload(:user)
    |> Repo.one()

  case last_workingtime do
    nil ->  # Aucun working time trouvé, création d'un nouveau
      new_workingtime = %Workingtimes{
        user_id: user_id,
        start_time: DateTime.now(),
        is_pause: false
      }
      {:ok, created_workingtime} = Repo.insert(new_workingtime)
      created_workingtime

    _ ->
      last_workingtime  # Utilisez le dernier working time existant
  end
end

 def list_workingtimes_filtered_by_current_working_day(user_id, previous_day, current_date)
      when is_binary(user_id) and is_binary(previous_day) and is_binary(current_date) do
    startTimeOfTheCurrentDay =
      from(w in Workingtimes,
        where:
          w.user_id == ^user_id and
            w.start_time >= ^previous_day and
            w.is_pause == false,
        order_by: [desc: w.start_time],
        select: w.end_time,
        limit: 1
      )
    case Repo.one(startTimeOfTheCurrentDay) do
      %DateTime{}  = start_time ->
        query =
          from(w in Workingtimes,
            where:
              w.user_id == ^user_id and
                w.start_time >= ^start_time,
            select: w
          )
        query_with_preload = Ecto.Query.preload(query, :user)
        workingtimes = Repo.all(query_with_preload)
        workingtimes
      nil ->
        []
    end
  end
end
