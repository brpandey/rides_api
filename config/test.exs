use Mix.Config

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :rides_api, RidesApiWeb.Endpoint,
  http: [port: 4001],
  server: false

# Print only warnings and errors during test
config :logger, level: :warn

# Configure your database
config :rides_api, RidesApi.Repo,
  adapter: Ecto.Adapters.Postgres,
  username: "postgres",
  password: "postgres",
  database: "rides_api_test",
  hostname: "localhost",
  pool: Ecto.Adapters.SQL.Sandbox,
  ownership_timeout: 50_000

config :rides_api, RidesApi.Scheduler,
  jobs: [
    # runs clean every minute for test
    {"5 * * * *", {RidesApi.Repo, :clean, [:feeds]}}
  ]

# to test run iex -S mix test

# crontab format

# * * * * * *
# | | | | | | 
# | | | | | +-- Year              (range: 1900-3000)
# | | | | +---- Day of the Week   (range: 1-7, 1 standing for Monday)
# | | | +------ Month of the Year (range: 1-12)
# | | +-------- Day of the Month  (range: 1-31)
# | +---------- Hour              (range: 0-23)
# +------------ Minute            (range: 0-59)
