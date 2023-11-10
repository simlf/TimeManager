defmodule TimeManagerWeb.Router do
  use TimeManagerWeb, :router
#A DELETE APRES
  import TimeManager.UserAuth

  pipeline :api do
    plug :fetch_session
    plug :accepts, ["json"]
    plug :put_secure_browser_headers
    plug :fetch_current_user
  end

  scope "/api", TimeManagerWeb do
    pipe_through :api

    post "/users/log_in", UserController, :connection

    post "/workingtimes/:user_id", WorkingtimesController, :create_by_user_id
    get "/workingtimes/last/:user_id", WorkingtimesController, :get_last_workingtime_by_user_id
    get "/workingtimes/:user_id/:id", WorkingtimesController, :get_by_id
    delete "/workingtimes/:id", WorkingtimesController, :delete
    put "/workingtimes/:id", WorkingtimesController, :update
    get "/workingtimes/:user_id", WorkingtimesController, :get_all_by_id
    get "/times/:user_id", WorkingtimesController, :get_time_from_workingtimes_by_user_id
    get "/times/thisDay/:user_id", WorkingtimesController, :get_time_from_workingtimes_current_day_by_user_id
    get "/times/info/:user_id", WorkingtimesController, :get_global_time_from_workingtimes_by_user_id

    get "/clocks/:userId", ClockController, :show_clocks_by_user_id
    post "/clocks/:userId", ClockController, :create
    put "/clocks/:userId", ClockController, :update
  end

  @doc """
  Used for routes that require the user to be authenticated and :EMPLOYEE
  """
  scope "/api", TimeManagerWeb do
    pipe_through [:api, :require_authenticated_user]

    get "/users/check_auth", UserController, :check_auth
    put "/users/me", UserController, :update_me
    put "/users/update_password/:id", UserController, :password_update
    get "/users/log_out", UserController, :log_out
  end

  @doc """
  Used for routes that require the user to be authenticated and :MANAGER
  """
  scope "/api", TimeManagerWeb do
    pipe_through [:api, :require_authenticated_manager_user]

  end

  @doc """
  Used for routes that require the user to be authenticated and :SUPER_MANAGER
  """
  scope "/api", TimeManagerWeb do
    pipe_through [:api, :require_authenticated_super_manager_user]

    resources "/users", UserController, only: [:delete, :index]
    resources "/groups", GroupController, only: [:index, :create, :delete]
    patch "/groups/:groupId/:userId", GroupController, :remove_user_from_group
  end

  @doc """
  Used for routes that require the user to be authenticated and :SUPER_MANAGER OR :MANAGER
  """
  scope "/api", TimeManagerWeb do
    pipe_through [:api, :require_authenticated_managers_user]

    resources "/users", UserController, only: [:create, :update, :show]
    resources "/groups", GroupController, only: [:update, :show]
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
