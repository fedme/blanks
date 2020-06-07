# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :blanks,
  ecto_repos: [Blanks.Repo]

# Configures the endpoint
config :blanks, BlanksWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "ASnxPcw+Y7t3Shh2TSlgr5mUOAMRjfQVp+YShgRoJT7fr7XUABx4PbqM4I/yw9BU",
  render_errors: [view: BlanksWeb.ErrorView, accepts: ~w(html json), layout: false],
  pubsub_server: Blanks.PubSub,
  live_view: [signing_salt: "CVSwoK9h"]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
