defmodule TimeManagerWeb.Router do
  use TimeManagerWeb, :router

  pipeline :api do
    plug :fetch_session
    plug :accepts, ["json"]
  end

  scope "/api", TimeManagerWeb do
    pipe_through :api

    post "/users", UserController, :create
    get "/users/:id", UserController, :show
    post "/connection", UserController, :connection

    post "/workingtimes/:user_id", WorkingtimesController, :create_by_user_id
    get "/workingtimes/:user_id/:id", WorkingtimesController, :get_by_id
    delete "/workingtimes/:id", WorkingtimesController, :delete
    put "/workingtimes/:id", WorkingtimesController, :update
    get "/workingtimes/:user_id", WorkingtimesController, :get_all_by_id

    get "/clocks/users/:userId", ClockController, :showClocksByUserId
    post "/clocks/users/:userId", ClockController, :create
    put "/clocks/users/:userId", ClockController, :update

  end

  # Enable LiveDashboard in development
  if Application.compile_env(:phx_api, :dev_routes) do
    # If you want to use the LiveDashboard in production, you should put
    # it behind authentication and allow only admins to access it.
    # If your application does not have an admins-only section yet,
    # you can use Plug.BasicAuth to set up some basic authentication
    # as long as you are also using SSL (which you should anyway).
    import Phoenix.LiveDashboard.Router

    scope "/dev" do
      pipe_through [:fetch_session, :protect_from_forgery]

      live_dashboard "/dashboard", metrics: TimeManagerWeb.Telemetry
    end
  end
end
