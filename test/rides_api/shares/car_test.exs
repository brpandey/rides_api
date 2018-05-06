defmodule RidesApi.Shares.CarRepoTest do
  use RidesApi.DataCase
  alias RidesApi.{Factory, Shares.Car}

  @valid_attrs %{name: "Mirai"}
  @invalid_attrs %{name: 123}

  test "basic create" do
    {:ok, %Car{name: "Mirai"}} = Car.create(@valid_attrs)
  end

  test "duplicate create" do
    {:ok, %Car{name: "Mirai"}} = Car.create(@valid_attrs)

    {:error, %Ecto.Changeset{errors: e}} = Car.create(@valid_attrs)
    assert [name: {"has already been taken", []}] == e
  end

  test "erroneous create" do
    {:error, %Ecto.Changeset{errors: e}} = Car.create(@invalid_attrs)
    assert [name: {"is invalid", [type: :string, validation: :cast]}] == e
  end

  test "ensure random is unique" do
    size = 10
    min_keys_rand = 3

    Factory.insert_list(Car, %{name: "Mirai"}, size, :repeating_suffix)

    list = Stream.cycle([0]) |> Enum.take(size)

    # Get list of 10 random cars
    l =
      Enum.reduce(list, [], fn _n, acc ->
        %Car{name: x} = Car.random()
        [x] ++ acc
      end)

    # We put values into a map using their name length as the key
    output = Enum.group_by(l, &String.length/1)

    # To validate that output is sufficiently random enough
    # Let's create simple heuristic

    # Let's say that given 10 unique cars each with 10 unique name lengths,
    # take 10 randomly,
    # We will expect to have atleast 3 groupings of names 
    # to ensure random is sufficiently random

    # Clearly if random wasn't working we may get the same name
    # Hence this would be 1 grouping
    num_keys = output |> Map.keys() |> Enum.count()

    assert num_keys >= min_keys_rand
  end
end
