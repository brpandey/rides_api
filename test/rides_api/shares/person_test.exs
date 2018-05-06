defmodule RidesApi.Shares.PersonRepoTest do
  use RidesApi.DataCase
  alias RidesApi.{Factory, Shares.Person}

  @valid_attrs %{name: "Kengo"}
  @invalid_attrs %{name: 123}

  test "basic create" do
    {:ok, %Person{name: "Kengo"}} = Person.create(@valid_attrs)
  end

  test "duplicate create" do
    {:ok, %Person{name: "Kengo"}} = Person.create(@valid_attrs)

    {:error, %Ecto.Changeset{errors: e}} = Person.create(@valid_attrs)
    assert [name: {"has already been taken", []}] == e
  end

  test "erroneous create" do
    {:error, %Ecto.Changeset{errors: e}} = Person.create(@invalid_attrs)
    assert [name: {"is invalid", [type: :string, validation: :cast]}] == e
  end

  test "ensure randoms are unique" do
    size = 10

    # create 10 persons
    Factory.insert_list(Person, %{name: "Kengo"}, size, :sequence)

    # Run ten times to fetch driver and passenger randomly
    # Ensure they never equal each other
    for _n <- 1..size do
      [%Person{name: x}, %Person{name: y}] = Person.randoms(2)
      assert false == String.equivalent?(x, y)
    end
  end
end
