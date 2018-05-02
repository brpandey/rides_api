defmodule RidesApi.Repo.Migrations.CreatePersons do
  use Ecto.Migration

  def change do
    create table(:persons) do
      add(:name, :string, null: false)

      timestamps()
    end

    # Create database constraint 
    # Ensure we don't have multiple passenger records with the same name
    # a single name corresponds to a single passenger

    create(unique_index(:persons, [:name]))
  end
end
