# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# General application configuration
config :the_transcriber_backend,
  ecto_repos: [TheTranscriberBackend.Repo]

# Configures the endpoint
config :the_transcriber_backend, TheTranscriberBackend.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "0yJGL4kD9IVayiDhe0WXbB5tavo4cap0+zNWqjT3LRfFC5bbyCWz9wrttCkhi1lw",
  render_errors: [view: TheTranscriberBackend.ErrorView, accepts: ~w(html json)],
  pubsub: [name: TheTranscriberBackend.PubSub,
           adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"
