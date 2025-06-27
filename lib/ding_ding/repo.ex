defmodule DingDing.Repo do
  use Ecto.Repo,
    otp_app: :ding_ding,
    adapter: Ecto.Adapters.Postgres
end
