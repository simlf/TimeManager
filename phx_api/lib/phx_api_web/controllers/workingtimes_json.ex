defmodule TimeManagerWeb.WorkingtimesJSON do
  alias TimeManager.Workingtime.Workingtimes


  @doc """
  Renders a list of workingtimes.
  """
  def index(%{workingtimes: workingtimes}) do
    %{data: for(workingtimes <- workingtimes, do: data(workingtimes))}
  end

  @doc """
  Renders a single workingtimes.
  """
  def show(%{workingtime: workingtime}) do
    %{data: data(workingtime)}
  end

  def showTimes(%{hours: hours, minutes: minutes, seconds: seconds}) do
  %{data: %{hours: hours, minutes: minutes, seconds: seconds}}
  end

  defp data(%Workingtimes{} = workingtime) do
    %{
      id: workingtime.id,
      start_time: workingtime.start_time,
      end_time: workingtime.end_time,
      user_id: workingtime.user_id,
      is_pause: workingtime.is_pause
    }
  end
end
