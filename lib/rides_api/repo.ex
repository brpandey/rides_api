defmodule RidesApi.Repo do
  # Injects the Ecto repo functions into the RidesApi app
  # Enables Ecto functionality

  use Ecto.Repo, otp_app: :rides_api

  @doc """
  Dynamically loads the repository url from the
  DATABASE_URL environment variable.
  """
  def init(_, opts) do
    {:ok, Keyword.put(opts, :url, System.get_env("DATABASE_URL"))}
  end

  @doc """
  Ensure we keep the feed database from growing to large
  Trigger by scheduler to clean occasionally

  Clearly a lean database!
  """
  def clean(:feeds) do
    RidesApi.Repo.delete_all(RidesApi.Shares.Feed)
  end
end
