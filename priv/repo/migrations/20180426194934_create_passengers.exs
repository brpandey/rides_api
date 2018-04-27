defmodule RidesApi.Repo.Migrations.CreatePassengers do
  use Ecto.Migration

  def change do
    create table(:passengers) do
      add(:name, :string, null: false)

      timestamps()
    end

    # Create database constraint 
    # Ensure we don't have multiple passenger records with the same name
    # a single name corresponds to a single passenger

    create(unique_index(:passengers, [:name]))
  end
end
