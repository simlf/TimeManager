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
            ((w.start_time >= ^start_time and w.end_time <= ^end_time) or
               (w.start_time <= ^start_time and w.end_time >= ^start_time) or
               (w.start_time <= ^end_time and w.end_time >= ^end_time)),
        order_by: [asc: w.id],
        select: w
      )

    query_with_preload = Ecto.Query.preload(query, :user)
    workingtimes = Repo.all(query_with_preload)
    workingtimes
  end

  def get_info_by_day_from_period(user_id, start_time, end_time) do
    sql =
      "SELECT date(start_time) AS date, array_agg((start_time, end_time, is_pause, type)) AS data FROM workingtimes WHERE user_id = '#{user_id}' AND ( start_time >= '#{start_time}' and end_time <= '#{end_time}') OR (start_time <= '#{start_time}' and end_time >= '#{start_time}') OR (start_time <= '#{end_time}' and end_time >= '#{end_time}') GROUP BY date(start_time) ORDER BY date;"

    Ecto.Adapters.SQL.query(Repo, sql, [])
  end

  def list_workingtimes_filtered_focus_on_pause(user_id, start_time, end_time, is_pause)
      when is_binary(user_id) and is_binary(start_time) and is_binary(end_time) do
    query =
      from(w in Workingtimes,
        where:
          w.user_id == ^user_id and
            w.start_time >= ^start_time and
            w.end_time <= ^end_time and
            w.is_pause == ^is_pause,
        order_by: [desc: w.start_time],
        select: w
      )

    query_with_preload = Ecto.Query.preload(query, :user)
    workingtimes = Repo.all(query_with_preload)
    workingtimes
  end

  def get_last_workingtime(user_id) when is_binary(user_id) do
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
      # Aucun working time trouvé
      nil ->
        []

      _ ->
        last_workingtime
    end
  end

  def list_workingtimes_filtered_by_current_working_day(user_id)
      when is_binary(user_id) do
    last_start =
      from(w in TimeManager.Workingtime.Workingtimes,
        where: w.type == ^:start_work and w.user_id == ^user_id,
        order_by: [desc: w.start_time],
        limit: 1
      )
      |> Ecto.Query.preload(:user)
      |> TimeManager.Repo.one()

    last_end =
      from(w in TimeManager.Workingtime.Workingtimes,
        where: w.type == ^:end_work and w.user_id == ^user_id,
        order_by: [desc: w.start_time],
        limit: 1
      )
      |> Ecto.Query.preload(:user)
      |> TimeManager.Repo.one()

    filtered_workingtimes =
      cond do
        !is_nil(last_start) && (is_nil(last_end) || last_start.start_time > last_end.start_time) ->
          IO.puts(
            "Le dernier 'end' est vide ou le dernier 'start' est plus récent que le dernier 'end'."
          )

          IO.puts("On peut donc se fier au start_time du dernier start.")
          IO.puts("On retourne tous les enregistrements à partir de start_time à maintenant.")
          end_time = DateTime.truncate(DateTime.utc_now(), :second)
          formatted_end_time = DateTime.to_string(end_time) |> String.slice(0..-2)
          formatted_start_time = DateTime.to_string(last_start.start_time) |> String.slice(0..-2)

          list_workingtimes_filtered_focus_on_pause(
            user_id,
            formatted_start_time,
            formatted_end_time,
            false
          )

        true ->
          IO.puts("Par defaut on retourne aucun enregistrement.")
          []
      end

    filtered_workingtimes
  end
end
