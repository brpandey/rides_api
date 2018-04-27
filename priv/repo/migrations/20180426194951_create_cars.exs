defmodule RidesApi.Repo.Migrations.CreateCars do
  use Ecto.Migration

  def change do
    create table(:cars) do
      add(:name, :string, null: false)

      timestamps()
    end

    # Create database constraint 
    # Ensure we don't have multiple car models with the same name
    # a single name corresponds to a single car model

    create(unique_index(:cars, [:name]))
  end
end
