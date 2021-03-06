# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :naive_dice,
  ecto_repos: [NaiveDice.Repo]

# Configures the endpoint
config :naive_dice, NaiveDiceWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "JvdAK76n53ApcZVDT3awEijcXOUVcwAxDG5Qza3KduNqVbGZhV2rb8PT9u4mq4zw",
  render_errors: [view: NaiveDiceWeb.ErrorView, accepts: ~w(html json)],
  pubsub: [name: NaiveDice.PubSub, adapter: Phoenix.PubSub.PG2]

config :naive_dice, Stripe,
  api_key: System.get_env("STRIPE_API_KEY"),
  public_key: System.get_env("STRIPE_PUBLIC_KEY")

# 5 minutes
config :naive_dice, :reservation_time, 5 * 60 * 1000

# 2 seconds
config :naive_dice, :tickets_cleaning_period, 2 * 1000

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
