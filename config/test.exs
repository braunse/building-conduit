use Mix.Config

# Configure your database
#
# The MIX_TEST_PARTITION environment variable can be used
# to provide built-in test partitioning in CI environment.
# Run `mix help test` for more information.
config :conduit, Conduit.Repo,
  username: "postgres",
  password: "supersecurepgpassword",
  database: "conduit_readstore_test#{System.get_env("MIX_TEST_PARTITION")}",
  hostname: "localhost",
  port: 8432,
  pool: Ecto.Adapters.SQL.Sandbox

config :conduit, Conduit.EventStore,
  username: "postgres",
  password: "supersecurepgpassword",
  database: "conduit_eventstore_test#{System.get_env("MIX_TEST_PARTITION")}",
  hostname: "localhost",
  port: 8432

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :conduit, ConduitWeb.Endpoint,
  http: [port: 4002],
  server: false

# Print only warnings and errors during test
config :logger, level: :warn

config :conduit, ConduitWeb.Auth.Token,
  secret_key: "XWuiyYw89PvzzIPrCwvrhrvCvEc8LMhezAH0B2pVpfjGn4lcGXPFlUqYDddcNyRi"
