defmodule Gothamapi.Repo do
  use Ecto.Repo,
    otp_app: :gothamapi,
    adapter: Ecto.Adapters.Postgres
end
