defmodule RidesApiWeb.GinzaView do
  use RidesApiWeb, :view
  alias RidesApiWeb.GinzaView

  def render("index.json", %{ginza: feeds}) do
    %{rides: render_many(feeds, GinzaView, "feed.json")}
  end

  def render("feed.json", %{ginza: feed}) do
    %{
      driver: feed.driver,
      passenger: feed.passenger,
      created_at: feed.created_at,
      car: feed.car
    }
  end
end
