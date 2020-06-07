defmodule Blanks.Repo do
  use Ecto.Repo,
    otp_app: :blanks,
    adapter: Ecto.Adapters.Postgres
end
