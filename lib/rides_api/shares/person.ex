defmodule RidesApi.Shares.Person do
  use Ecto.Schema
  import Ecto.Changeset
  import Ecto.Query

  alias RidesApi.{Shares.Person, Repo}

  schema "persons" do
    field(:name, :string)

    timestamps()
  end

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
