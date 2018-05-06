defmodule RidesApi.Factory do
  @moduledoc """
  Convenience functions for setting up test db data

  Somewhat resembles ExMachina
  """

  alias RidesApi.{Repo, Shares.Car, Shares.Person}

  # 	Factories

  def build(Car) do
    %Car{name: "some car"}
  end

  def build(Person) do
    %Person{name: "some person"}
  end

  #  def build_pair(Person, :random) do
  #    build_list(2, Person, attrs)
  #  end

  # Convenience functions

  def build(schema, attrs) do
    schema
    |> build()
    |> struct(attrs)
  end

  def insert(schema, attrs \\ []) do
    Repo.insert!(build(schema, attrs))
  end

  def insert_list(schema, %{} = attrs, size, :sequence)
      when is_integer(size) do
    # Generates a list of schemas to be inserted

    # For each list item append the suffix starting from 1
    # Thus the names follow a sequence name1, name2, etc.. until and including size

    # Pass in the identity function
    lambda = & &1

    do_insert_list(schema, attrs, size, lambda)
  end

  def insert_list(schema, %{} = attrs, size, :repeating_suffix)
      when is_integer(size) do
    # Generates a list of schemas to be inserted

    # The larger the n, the more we repeat the suffix
    # So if n is 3, repeat the string "3" three times
    # This is hence the string suffix appended to the name

    lambda = fn n -> Stream.cycle([n]) |> Enum.take(n) |> Enum.join() end

    do_insert_list(schema, attrs, size, lambda)
  end

  def do_insert_list(schema, %{name: name}, size, suffix_fn)
      when is_integer(size) and is_function(suffix_fn, 1) do
    # Perform a list comprehension inserting over the course of the list
    for n <- 1..size do
      suffix = suffix_fn.(n)
      insert(schema, %{name: "#{name}#{suffix}"})
    end

    :ok
  end
end
