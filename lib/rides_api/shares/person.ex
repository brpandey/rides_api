defmodule RidesApi.Shares.Person do
  @moduledoc """
  Mapper module for persons table
  Provides validation and casting support as well as 
  convenience db methods to create, and retrieve random persons
  """

  use Ecto.Schema
  import Ecto.Changeset
  import Ecto.Query

  alias RidesApi.{Shares.Person, Repo}

  schema "persons" do
    field(:name, :string)

    timestamps()
  end

  @doc """
  Casts and validates requirements, ensures name is unique
  """
  def changeset(feed, attrs) do
    feed
    |> cast(attrs, [:name])
    |> validate_required([:name])
    |> unique_constraint(:name)
  end

  @doc "Creates person record"
  def create(%{} = params), do: changeset(%Person{}, params) |> Repo.insert()

  @doc "Returns random set of persons denoted by size n"
  def randoms(size) when is_integer(size) do
    Repo.all(from(p in Person, order_by: fragment("RANDOM()"), limit: ^size))
  end
end
