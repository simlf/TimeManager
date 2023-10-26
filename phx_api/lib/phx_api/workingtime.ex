defmodule TimeManager.Workingtime do
  @moduledoc """
  The Workingtime context.
  """

  import Ecto.Query, warn: false
  alias TimeManager.Repo
  use Timex
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

  def list_workingtimes_filtered(user_id, start, end_time) when is_binary(user_id) and is_binary(start) and is_binary(end_time) do
    query = from(w in Workingtimes,
                where: w.user_id == ^user_id and
                       w.start >= ^start and
                       w.end_time <= ^end_time,
                order_by: [desc: w.start],
                select: w,
               )
    query_with_preload = Ecto.Query.preload(query, :user)
    workingtimes = Repo.all(query_with_preload)
    workingtimes
  end

end
