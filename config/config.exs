# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :blogr,
  ecto_repos: [Blogr.Repo]

# Configures the endpoint
config :blogr, BlogrWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "mNQ3QyVPL91xxD1SB7ZFycAvjnMZ1pJloytN77t6zP3h/ggKQxWj3NxONI6E/++G",
  render_errors: [view: BlogrWeb.ErrorView, accepts: ~w(html json), layout: false],
  pubsub_server: Blogr.PubSub,
  live_view: [signing_salt: "s/OvaNsj"]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
