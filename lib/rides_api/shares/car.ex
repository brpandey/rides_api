defmodule RidesApi.Shares.Car do
  use Ecto.Schema
  import Ecto.Changeset
  import Ecto.Query

  alias RidesApi.{Shares.Car, Repo}

  schema "cars" do
    field(:name, :string)

    timestamps()
  end

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
