defmodule RidesApi.Rentals.Person do
  use Ecto.Schema
  import Ecto.Changeset

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
end
