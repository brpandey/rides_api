defmodule RidesApi.Shares.Car do
  @moduledoc """
  Mapper module for cars table
  Provides validation and casting support as well as 
  convenience db methods to create, and retrieve random cars
  """

  use Ecto.Schema
  import Ecto.Changeset
  import Ecto.Query

  alias RidesApi.{Shares.Car, Repo}

  schema "cars" do
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

  @doc "Creates car record"
  def create(%{} = params), do: changeset(%Car{}, params) |> Repo.insert()

  @doc "Returns random car"
  def random() do
    Repo.one(from(c in Car, order_by: fragment("RANDOM()"), limit: 1))
  end
end
