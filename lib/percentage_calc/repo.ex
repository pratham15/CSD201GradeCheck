defmodule PercentageCalc.Repo do
  use Ecto.Repo,
    otp_app: :percentage_calc,
    adapter: Ecto.Adapters.Postgres
end
