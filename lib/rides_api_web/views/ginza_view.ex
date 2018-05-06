defmodule RidesApiWeb.GinzaView do
  use RidesApiWeb, :view
  alias RidesApiWeb.GinzaView

  @doc "Provides index json render clause for ginza feeds"
  def render("index.json", %{ginza: feeds}) do
    %{rides: render_many(feeds, GinzaView, "feed.json")}
  end

  @doc "Provides single feed json render clause for ginza feeds"
  def render("feed.json", %{ginza: feed}) do
    %{
      driver: feed.driver,
      passenger: feed.passenger,
      created_at: feed.created_at,
      car: feed.car
    }
  end
end
