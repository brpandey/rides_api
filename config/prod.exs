use Mix.Config

# For production, we often load configuration from external
# sources, such as your system environment. For this reason,
# you won't find the :http configuration below, but set inside
# RidesApiWeb.Endpoint.init/2 when load_from_system_env is
# true. Any dynamic configuration should be done there.
#
# Don't forget to configure the url host to something meaningful,
# Phoenix uses this information when generating URLs.
#
# Finally, we also include the path to a cache manifest
# containing the digested version of static files. This
# manifest is generated by the mix phx.digest task
# which you typically run after static files are built.
config :rides_api, RidesApiWeb.Endpoint,
  load_from_system_env: true,
  # Without this line, your app will not start the web server!
  server: true,
  secret_key_base: System.get_env("SECRET_KEY_BASE"),
  url: [host: "localhost", port: System.get_env("PORT")]

#  cache_static_manifest: "priv/static/cache_manifest.json"

config :rides_api, RidesApi.Repo,
  adapter: Ecto.Adapters.Postgres,
  username: System.get_env("DB_USER_NAME"),
  password: System.get_env("DB_USER_PASSWORD"),
  database: "rides_api_prod",
  url: System.get_env("DATABASE_URL"),
  # Free tier db only allows 1 connection
  pool_size: 1,
  ssl: true

# Do not print debug messages in production
config :logger, level: :info

config :rides_api, RidesApi.Scheduler,
  jobs: [
    # runs clean daily at midnight
    {"@daily", {RidesApi.Repo, :clean, [:feeds]}}
  ]

# ## SSL Support
#
# To get SSL working, you will need to add the `https` key
# to the previous section and set your `:url` port to 443:
#
#     config :rides_api, RidesApiWeb.Endpoint,
#       ...
#       url: [host: "example.com", port: 443],
#       https: [:inet6,
#               port: 443,
#               keyfile: System.get_env("SOME_APP_SSL_KEY_PATH"),
#               certfile: System.get_env("SOME_APP_SSL_CERT_PATH")]
#
# Where those two env variables return an absolute path to
# the key and cert in disk or a relative path inside priv,
# for example "priv/ssl/server.key".
#
# We also recommend setting `force_ssl`, ensuring no data is
# ever sent via http, always redirecting to https:
#
#     config :rides_api, RidesApiWeb.Endpoint,
#       force_ssl: [hsts: true]
#
# Check `Plug.SSL` for all available options in `force_ssl`.

# ## Using releases
#
# If you are doing OTP releases, you need to instruct Phoenix
# to start the server for all endpoints:
#
#     config :phoenix, :serve_endpoints, true
#
# Alternatively, you can configure exactly which server to
# start per endpoint:
#
#     config :rides_api, RidesApiWeb.Endpoint, server: true
#

# Finally import the config/prod.secret.exs
# which should be versioned separately.
# import_config "prod.secret.exs"
