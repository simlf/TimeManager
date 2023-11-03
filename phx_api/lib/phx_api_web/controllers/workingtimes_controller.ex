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
      |> render("show.json", workingtime: workingtime)
    end
  end
def create(conn, %{"workingtimes" => workingtimes_params}) do
  with {:ok, %Workingtimes{} = workingtime} <- Workingtime.create_workingtimes(workingtimes_params) do
    conn
    |> put_status(:created)
    |> render("show.json", workingtime: workingtime)
  end
end



  @doc """
  Returns an `%Ecto.Changeset{}` for tracking workingtimes changes.

  ## Examples

      iex> change_workingtimes(workingtimes)
      %Ecto.Changeset{data: %Workingtimes{}}

  """

  def get_by_id(conn, %{"id" => id, "user_id" => _user_id}) do
    workingtime = Workingtime.get_workingtimes!(id)
    render(conn, "show.json", workingtime: workingtime)
  end

  def get_all_by_id(conn, %{"user_id" => user_id}) do
    start_time = conn.query_params["start_time"]
    end_time = conn.query_params["end_time"]

    workingtimes = Workingtime.list_workingtimes_filtered(user_id, start_time, end_time)

    render(conn, "index.json", workingtimes: workingtimes)
  end

  def show(conn, %{"id" => id}) do
    workingtime = Workingtime.get_workingtimes!(id)
    render(conn, "show.json", workingtime: workingtime)
  end

  def update(conn, %{"id" => id, "workingtimes" => workingtimes_params}) do
    workingtime = Workingtime.get_workingtimes!(id)

    with {:ok, %Workingtimes{} = workingtime} <- Workingtime.update_workingtimes(workingtime, workingtimes_params) do
      render(conn, "show.json", workingtime: workingtime)
    end
  end

  def delete(conn, %{"id" => id}) do
    workingtime = Workingtime.get_workingtimes!(id)

    with {:ok, %Workingtimes{}} <- Workingtime.delete_workingtimes(workingtime) do
      conn
      |> put_status(:ok)
      |> put_resp_header("content-type", "application/json")
      |> text("WorkingTime with ID:#{id} Deleted")
    end
  end

  def get_time_from_workingtimes_by_user_id(conn, %{"user_id" => user_id})do
    start_time = conn.query_params["start_time"]
    end_time = conn.query_params["end_time"]

    workingtimes = Workingtime.list_workingtimes_filtered(user_id, start_time, end_time)
    total_seconds = calculate_total_times(workingtimes)
    render(conn, "showTimes.json", seconds_to_hms(total_seconds))
  end

  def get_time_from_workingtimes_current_day_by_user_id(conn, %{"user_id" => user_id})do
    current_date = Timex.now()
    previous_day = Timex.shift(current_date, days: -1)
    current_date_formatted = Timex.format!(current_date, "%Y-%m-%d %H:%M:%S", :strftime)
    previous_day_formatted = Timex.format!(previous_day, "%Y-%m-%d %H:%M:%S", :strftime)

    workingtimes = Workingtime.list_workingtimes_filtered_by_current_working_day(user_id, previous_day_formatted, current_date_formatted)
    total_seconds = calculate_total_times(workingtimes)
    render(conn, "showTimes.json", seconds_to_hms(total_seconds))
  end

  defp calculate_total_times(workingtimes, total_hours \\ 0) do
  case workingtimes do
    [] -> total_hours
    [workingtime | rest] ->
      time_worked = calculate_workingtime(workingtime)
      updated_total_hours = total_hours + time_worked
      calculate_total_times(rest, updated_total_hours)
  end
end

  defp calculate_workingtime(workingtime) do

    start_time = Timex.parse!(Timex.format!(workingtime.start_time, "{ISO:Extended:Z}"), "{ISO:Extended:Z}")
    end_time = Timex.parse!(Timex.format!(workingtime.end_time, "{ISO:Extended:Z}"), "{ISO:Extended:Z}")
    time_worked = Timex.diff(end_time, start_time, :second) # Utilisez :second (au singulier)

    time_worked
  end

  defp seconds_to_hms(total_seconds) do
    hours = div(total_seconds, 3600)
    remaining_seconds = rem(total_seconds, 3600)
    minutes = div(remaining_seconds, 60)
    seconds = rem(remaining_seconds, 60)

    %{hours: hours, minutes: minutes, seconds: seconds}
  end

end
