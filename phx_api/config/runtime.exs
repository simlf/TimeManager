import Config

if System.get_env("PHX_SERVER") do
  config :phx_api, TimeManagerWeb.Endpoint, server: true
end

if config_env() == :prod do


  config :phx_api, TimeManager.Repo,
    username: System.get_env("PGUSER"),
    password: System.get_env("POSTGRES_PASSWORD"),
    hostname: System.get_env("PGHOST"),
    database: System.get_env("PGDATABASE"),
    port: System.get_env("PGPORT"),
    stacktrace: true,
    show_sensitive_data_on_connection_error: true,
    pool_size: 10

  config :phx_api, TimeManagerWeb.Endpoint,
    url: [host: "phx.time-manager-batman.com", port: 443, scheme: "https"],
    http: [
      ip: {0, 0, 0, 0},
      port: 4000
    ],
    check_origin: false,
    code_reloader: true,
    debug_errors: true,
    secret_key_base: "AMudzdI8fZsC/J32aq/k6qvzFyktzT/q9yvGoKsjnEXGSIZr+JKEujJ7VYz7ssV+",
    watchers: [],
    cors: [
      origins: ["https://www.time-manager-batman.com", "https://test.time-manager-batman.com"],
      headers: ~w(Content-Type)
    ]
end
