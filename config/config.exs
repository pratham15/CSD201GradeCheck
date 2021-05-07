# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :percentage_calc,
  ecto_repos: [PercentageCalc.Repo]

# Configures the endpoint
config :percentage_calc, PercentageCalcWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "PR8+C3VI5vdfVPcq4/oIRl8LVgO5UC73pSkO5JwWDIjBcC6PYZuwjVc14vceHbKq",
  render_errors: [view: PercentageCalcWeb.ErrorView, accepts: ~w(html json), layout: false],
  pubsub_server: PercentageCalc.PubSub,
  live_view: [signing_salt: "Wzl8yZQp"]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
