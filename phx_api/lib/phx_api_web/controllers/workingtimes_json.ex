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
  def show(%{workingtimes: workingtimes}) do
    %{data: data(workingtimes)}
  end

  def showHours(%{hours: hours}) do
    %{hours: hours}
  end

  defp data(%Workingtimes{} = workingtimes) do
    %{
      id: workingtimes.id,
      start: workingtimes.start,
      end_time: workingtimes.end_time,
      user_id: workingtimes.user_id
    }
  end
end
