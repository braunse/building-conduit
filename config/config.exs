# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :conduit,
  ecto_repos: [Conduit.Repo]

# Configures the endpoint
config :conduit, ConduitWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "60Wv6qc7v4nsGYs1++4EBIsFSO3yOvJir/4f1YmGHwhng026U1YN1yXXChg1Psoi",
  render_errors: [view: ConduitWeb.ErrorView, accepts: ~w(json), layout: false],
  pubsub_server: Conduit.PubSub,
  live_view: [signing_salt: "e10yO2wG"]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

config :conduit, Conduit.Application,
  event_store: [
    adapter: Commanded.EventStore.Adapters.EventStore,
    event_store: Conduit.EventStore
  ],
  pubsub: :local,
  registry: :local

config :conduit, Conduit.EventStore,
  serializer: Commanded.Serialization.JsonSerializer

config :conduit, event_stores: [Conduit.EventStore]

config :vex,
  sources: [
    Conduit.Support.Validators,
    Conduit.Accounts.Validators,
    Conduit.Blog.Validators,
    Vex.Validators
  ]

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
