defmodule Party.Repo do
  use Ecto.Repo,
    otp_app: :party,
    adapter: Ecto.Adapters.SQLite3
end
