defmodule TimeManager.Repo do
  use Ecto.Repo,
    otp_app: :phx_api,
    adapter: Ecto.Adapters.Postgres
end
