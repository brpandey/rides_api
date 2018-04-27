# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# General application configuration
config :rides_api,
  ecto_repos: [RidesApi.Repo]

# Configures the endpoint
config :rides_api, RidesApiWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "iAxu0mW2cnloe7XlC23aUqbG7Ej8caAQV7OB1Fw2VUTy6Nv3/sViasYfaZgUT7aJ",
  render_errors: [view: RidesApiWeb.ErrorView, accepts: ~w(html json)],
  pubsub: [name: RidesApi.PubSub,
           adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:user_id]

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"
