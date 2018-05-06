defmodule RidesApi.Shares.CarRepoTest do
  use RidesApi.DataCase
  alias RidesApi.Shares.Car

  alias RidesApi.Test.Helper

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

    Helper.insert(:car, "Mirai", size)

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

    # Let's say that given 10 unique car each with 10 unique name lengths,
    # taken 10 randomly, we will have atleast 3 groupings of unique names

    # Clearly if random wasn't working we may get the same name
    # Hence this would be 1 grouping
    num_keys = output |> Map.keys() |> Enum.count()

    assert num_keys >= min_keys_rand
  end
end
