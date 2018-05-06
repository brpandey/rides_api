# RidesApi

mix archive.install https://github.com/phoenixframework/archives/raw/master/phx_new.ez

mix phx.new rides_api

mix phx.gen.json Rentals Feed feeds driver:string passenger:string created_at:integer car:string type:string

mix ecto.gen.migration create_passengers

mix ecto.gen.migration create_cars

mix compile

mix ecto.drop
mix ecto.create
mix ecto.migrate
mix run priv/repo/seeds.exs
