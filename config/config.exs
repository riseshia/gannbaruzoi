# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# General application configuration
config :gannbaruzoi_elixir,
  ecto_repos: [GannbaruzoiElixir.Repo]

# Configures the endpoint
config :gannbaruzoi_elixir, GannbaruzoiElixir.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "9wFfMKO7EPkb41ReVbJak16qk0IhOSD851mvUJJILsq4GK+2EmF+wEZOuP/HReUX",
  render_errors: [view: GannbaruzoiElixir.ErrorView, accepts: ~w(html json)],
  pubsub: [name: GannbaruzoiElixir.PubSub,
           adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"
