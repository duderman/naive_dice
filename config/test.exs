use Mix.Config

# Configure your database
config :naive_dice, NaiveDice.Repo,
  # username: "postgres",
  # password: "postgres",
  database: "naive_dice_test",
  hostname: "localhost",
  pool: Ecto.Adapters.SQL.Sandbox

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :naive_dice, NaiveDiceWeb.Endpoint,
  http: [port: 4002],
  server: false

config :naive_dice, Stripe, api_key: "STRIPE_API_KEY"

# Print only warnings and errors during test
config :logger, level: :warn

config :tesla, adapter: Tesla.Mock
