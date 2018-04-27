defmodule RidesApi.Repo.Migrations.CreateFeeds do
  use Ecto.Migration

  def change do
    create table(:feeds) do
      add(:driver, :string)
      add(:passenger, :string)
      add(:created_at, :integer)
      add(:car, :string)
      add(:type, :string)

      timestamps()
    end
  end
end
