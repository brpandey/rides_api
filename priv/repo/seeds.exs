# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     RidesApi.Repo.insert!(%RidesApi.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.

alias RidesApi.{Shares.Car, Shares.Person}

car_model_names =
  File.stream!("priv/static/data/toyota_2018_models.txt")
  |> CSV.decode!(headers: true)
  |> Enum.reduce([], fn %{"model_name" => v} = _row, acc -> [v] ++ acc end)
  |> Enum.reverse()

anime_names =
  File.stream!("priv/static/data/japanese_anime_character_names.txt")
  |> CSV.decode!(separator: ?,)
  |> Enum.map(fn v -> v end)
  |> List.flatten()

# Normalize the lists into lists of the relevant structs
c_list = car_model_names |> Enum.map(fn n -> %{name: "Toyota #{n}"} end)
p_list = anime_names |> Enum.map(fn p -> %{name: p} end)

c_list |> Enum.each(fn c -> {_a, _c} = Car.create(c) end)
p_list |> Enum.each(fn p -> {_a, _p} = Person.create(p) end)

:ok
