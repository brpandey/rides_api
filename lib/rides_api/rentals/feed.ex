defmodule RidesApi.Rentals.Feed do
  use Ecto.Schema
  import Ecto.Changeset

  schema "feeds" do
    field(:driver, :string)
    field(:car, :string)
    field(:passenger, :string)
    field(:created_at, :integer)
    field(:type, :string)

    timestamps()
  end

  @doc false
  def changeset(feed, attrs) do
    feed
    |> cast(attrs, [:driver, :passenger, :created_at, :car, :type])
    |> validate_required([:driver, :passenger, :created_at, :car, :type])
  end
end
