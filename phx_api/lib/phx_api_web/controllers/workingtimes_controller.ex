defmodule TimeManagerWeb.WorkingtimesController do
  use TimeManagerWeb, :controller

  alias TimeManager.Workingtime
  alias TimeManager.Workingtime.Workingtimes

  action_fallback TimeManagerWeb.FallbackController

  def index(conn, _params) do
    workingtimes = Workingtime.list_workingtimes()
    render(conn, :index, workingtimes: workingtimes)
  end

  def create(conn, %{"workingtimes" => workingtimes_params}) do
    with {:ok, %Workingtimes{} = workingtimes} <- Workingtime.create_workingtimes(workingtimes_params) do
      conn
      |> put_status(:created)
      |> render('show.json', workingtimes: workingtimes)
    end
  end

  def show(conn, %{"id" => id}) do
    workingtimes = Workingtime.get_workingtimes!(id)
    render(conn, :show, workingtimes: workingtimes)
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
      send_resp(conn, :no_content, "")
    end
  end
end
