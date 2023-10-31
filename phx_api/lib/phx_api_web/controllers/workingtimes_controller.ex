defmodule TimeManagerWeb.WorkingtimesController do
  use TimeManagerWeb, :controller
  use Timex
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
    end_time = conn.query_params["end"]

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

  def get_countHours_by_id(conn, %{"user_id" => user_id})do
    start = conn.query_params["start"]
    end_time = conn.query_params["end"]

    workingtimes = Workingtime.list_workingtimes_filtered(user_id, start, end_time)
    total_seconds = calculate_total_hours(workingtimes)
    IO.inspect("hours_worked : " <> Integer.to_string(total_seconds))

    hours = div(total_seconds, 3600)
    remaining_seconds = rem(total_seconds, 3600)
    minutes = div(remaining_seconds, 60)
    seconds = rem(remaining_seconds, 60)

    render(conn, "showTimes.json", hours: hours,minutes: minutes, seconds: seconds)
  end

  defp calculate_total_hours(workingtimes, total_hours \\ 0) do
  case workingtimes do
    [] -> total_hours
    [workingtime | rest] ->
      time_worked = calculate_workingtime(workingtime)
      updated_total_hours = total_hours + time_worked
      calculate_total_hours(rest, updated_total_hours)
  end
end

  defp calculate_workingtime(workingtime) do

    start_time = Timex.parse!(Timex.format!(workingtime.start, "{ISO:Extended:Z}"), "{ISO:Extended:Z}")
    end_time = Timex.parse!(Timex.format!(workingtime.end_time, "{ISO:Extended:Z}"), "{ISO:Extended:Z}")
    time_worked = Timex.diff(end_time, start_time, :second) # Utilisez :second (au singulier)

    time_worked
  end

end
