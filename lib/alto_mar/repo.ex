defmodule AltoMar.Repo do
  use Ecto.Repo,
    otp_app: :alto_mar,
    adapter: Ecto.Adapters.SQLite3
end
