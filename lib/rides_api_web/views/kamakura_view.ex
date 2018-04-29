defmodule RidesApiWeb.KamakuraView do
  use RidesApiWeb, :view
  alias RidesApiWeb.KamakuraView

  def render("index.json", %{kamakura: feeds}) do
    %{rides: render_many(feeds, KamakuraView, "feed.json")}
  end

  def render("show.json", %{kamakura: feed}) do
    %{rides: render_one(feed, KamakuraView, "feed.json")}
  end

  def render("feed.json", %{kamakura: feed}) do
    %{
      occupants: "#{feed.driver} - #{feed.passenger}",
      created_at: feed.created_at,
      car: feed.car
    }
  end
end
