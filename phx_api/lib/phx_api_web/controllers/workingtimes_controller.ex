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

    with {:ok, %Workingtimes{} = workingtime} <-
           Workingtime.create_workingtimes(workingtimes_params) do
      conn
      |> put_status(:created)
      |> render("show.json", workingtime: workingtime)
    end
  end

  def create(conn, %{"workingtimes" => workingtimes_params}) do
    with {:ok, %Workingtimes{} = workingtime} <-
           Workingtime.create_workingtimes(workingtimes_params) do
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
        IO.inspect(start_time)
        IO.inspect(end_time)
        IO.inspect(user_id)

    IO.puts("get_all_by_id")
    workingtimes = Workingtime.list_workingtimes_filtered(user_id, start_time, end_time)
    render(conn, "index.json", workingtimes: workingtimes)
  end

  def show(conn, %{"id" => id}) do
    workingtime = Workingtime.get_workingtimes!(id)
    render(conn, "show.json", workingtime: workingtime)
  end

  def update(conn, %{"id" => id, "workingtimes" => workingtimes_params}) do
    workingtime = Workingtime.get_workingtimes!(id)

    with {:ok, %Workingtimes{} = workingtime} <-
           Workingtime.update_workingtimes(workingtime, workingtimes_params) do
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

  def get_last_workingtime_by_user_id(conn, %{"user_id" => user_id}) do
    workingtime = Workingtime.get_last_workingtime(user_id)
    render(conn, "show.json", workingtime: workingtime)
  end

  def get_time_from_workingtimes_by_user_id(conn, %{"user_id" => user_id}) do
    start_time = conn.query_params["start_time"]
    end_time = conn.query_params["end_time"]

    workingtimes =
      cond do
        is_nil(Map.get(conn.query_params, "pause")) ->
          # Le paramètre "pause" n'est pas défini
          Workingtime.list_workingtimes_filtered(user_id, start_time, end_time)

        true ->
          # Le paramètre "pause" est défini, vous pouvez l'utiliser dans votre logique
          pause_param = Map.get(conn.query_params, "pause")

          Workingtime.list_workingtimes_filtered_focus_on_pause(
            user_id,
            start_time,
            end_time,
            pause_param
          )
      end

    total_seconds = calculate_total_times(workingtimes)
    render(conn, "showTimes.json", seconds_to_hms(total_seconds))
  end

  def get_time_from_workingtimes_current_day_by_user_id(conn, %{"user_id" => user_id}) do
    workingtimes = Workingtime.list_workingtimes_filtered_by_current_working_day(user_id)
    total_seconds = calculate_total_times(workingtimes)
    render(conn, "showTimes.json", seconds_to_hms(total_seconds))
  end

  def get_global_time_from_workingtimes_by_user_id(conn, %{"user_id" => user_id}) do
    start_time = conn.query_params["start_time"]
    end_time = conn.query_params["end_time"]

    data = Workingtime.get_info_by_day_from_period(user_id, start_time, end_time)
    requestData = elem(data, 1)
    numberOfElement = length(requestData.rows)

    {totalSecondsForPeriodPause, totalSecondsForPeriodWork, dateList} =
      Enum.reduce(0..numberOfElement, {0, 0, []}, fn x,
                                                     {acc_seconds_pause, acc_seconds_work,
                                                      acc_list} ->
        case {Enum.at(requestData.rows, x)} do
          {nil} ->
            {acc_seconds_pause, acc_seconds_work, acc_list}

          {date_info} ->
            currentDate = Enum.at(date_info, 0)

            case {Enum.at(date_info, 1)} do
              {nil} ->
                {acc_seconds_pause, acc_seconds_work, acc_list}

              {workingtimes} ->
                {totalSecondsForDatePause, totalSecondsForDateWorked} =
                  Enum.reduce(workingtimes, {0, 0}, fn s,
                                                       {acc_seconds_pause, acc_seconds_worked} ->
                    {start_time, end_time, is_pause} = {elem(s, 0), elem(s, 1), elem(s, 2)}

                    time_difference = calculate_time(start_time, end_time)

                    if is_pause do
                      {acc_seconds_pause + time_difference, acc_seconds_worked}
                    else
                      {acc_seconds_pause, acc_seconds_worked + time_difference}
                    end
                  end)

                hms_worked = seconds_to_hours(totalSecondsForDateWorked)
                hms_pause = seconds_to_hours(totalSecondsForDatePause)

                date_obj = %{
                  date: currentDate,
                  hours_pause: hms_pause.hours,
                  hours_work: hms_worked.hours
                }

                updated_list = [date_obj | acc_list]

                {acc_seconds_pause + totalSecondsForDatePause,
                 acc_seconds_work + totalSecondsForDateWorked, updated_list}
            end
        end
      end)

    dateList = Enum.reverse(dateList)

    render(conn, "showTimesInfo.json", %{
      dateList: dateList,
      timePause: seconds_to_hours(totalSecondsForPeriodPause),
      timeWork: seconds_to_hours(totalSecondsForPeriodWork)
    })
  end

  defp calculate_total_times(workingtimes, total_hours \\ 0) do
    case workingtimes do
      [] ->
        total_hours

      [workingtime | rest] ->
        time_worked = calculate_from_workingtime(workingtime)
        updated_total_hours = total_hours + time_worked
        calculate_total_times(rest, updated_total_hours)
    end
  end

  defp calculate_from_workingtime(workingtime) do
    start_time =
      Timex.parse!(Timex.format!(workingtime.start_time, "{ISO:Extended:Z}"), "{ISO:Extended:Z}")

    end_time =
      Timex.parse!(Timex.format!(workingtime.end_time, "{ISO:Extended:Z}"), "{ISO:Extended:Z}")

    calculate_time(start_time, end_time)
  end

  defp calculate_time(start_time, end_time) do
    time_worked = Timex.diff(end_time, start_time, :second)

    time_worked
  end

  defp seconds_to_hours(total_seconds) do
    hours = Float.round(total_seconds / 3600, 2)
    %{hours: hours}
  end

  defp seconds_to_hms(total_seconds) do
    hours = div(total_seconds, 3600)
    remaining_seconds = rem(total_seconds, 3600)
    minutes = div(remaining_seconds, 60)
    seconds = rem(remaining_seconds, 60)

    %{hours: hours, minutes: minutes, seconds: seconds}
  end
end
