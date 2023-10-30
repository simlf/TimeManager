defmodule TimeManagerWeb.WorkingtimesController do
  use TimeManagerWeb, :controller

  alias TimeManager.Workingtime
  alias TimeManager.Workingtime.Workingtimes

  def index(conn, _params) do
    workingtimes = Workingtime.list_workingtimes()

    render(conn, "index.json", workingtimes: workingtimes)
  end

  def create_by_user_id(conn, %{"user_id" => user_id, "workingtimes" => workingtimes_params}) do
    workingtimes_params = Map.put(workingtimes_params, "user_id", user_id)
    with {:ok, %Workingtimes{} = workingtime} <- Workingtime.create_workingtimes(workingtimes_params) do
      conn
      |> put_status(:created)
      |> render("show.json", workingtimes: workingtime)
    end
  end

  def create(conn, %{"workingtimes" => workingtimes_params}) do
    IO.inspect(workingtimes_params)
    with {:ok, %Workingtimes{} = workingtime} <- Workingtime.create_workingtimes(workingtimes_params) do
      conn
      |> put_status(:created)
      |> render("show.json", workingtimes: workingtime)
    end
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking workingtimes changes.

  ## Examples

      iex> change_workingtimes(workingtimes)
      %Ecto.Changeset{data: %Workingtimes{}}

  """

  def get_by_id(conn, %{"id" => id, "user_id" => _user_id}) do
    IO.inspect(id)
    workingtimes = Workingtime.get_workingtimes!(id)
    IO.inspect(workingtimes)
    render(conn, "show.json", workingtimes: workingtimes)
  end

  def get_all_by_id(conn, %{"user_id" => user_id}) do
    start = conn.query_params["start"]
    end_time = conn.query_params["end_time"]

    workingtimes = Workingtime.list_workingtimes_filtered(user_id, start, end_time)

    render(conn, "index.json", workingtimes: workingtimes)
  end

  def show(conn, %{"id" => id}) do
    workingtimes = Workingtime.get_workingtimes!(id)
    render(conn, "show.json", workingtimes: workingtimes)
  end

  def update(conn, %{"id" => id, "workingtimes" => workingtimes_params}) do
    workingtimes = Workingtime.get_workingtimes!(id)

    with {:ok, %Workingtimes{} = workingtimes} <- Workingtime.update_workingtimes(workingtimes, workingtimes_params) do
      render(conn, :show, workingtimes: workingtimes)
    end
  end

  def delete(conn, %{"id" => id}) do
    workingtimes = Workingtime.get_workingtimes!(id)

    with {:ok, %Workingtimes{}} <- Workingtime.delete_workingtimes(workingtimes) do
      conn
      |> put_status(:ok)
      |> put_resp_header("content-type", "application/json")
      |> text("User ID:#{id} Deleted")
    end
  end
end
