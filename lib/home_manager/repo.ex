defmodule HomeManager.Repo do
  use Ecto.Repo,
    otp_app: :home_manager,
    adapter: Ecto.Adapters.Postgres
end
