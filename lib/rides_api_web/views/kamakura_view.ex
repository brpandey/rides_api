defmodule RidesApiWeb.KamakuraView do
  use RidesApiWeb, :view
  alias RidesApiWeb.KamakuraView

  @doc "Provides index json render clause for kamakura feeds"
  def render("index.json", %{kamakura: feeds}) do
    %{rides: render_many(feeds, KamakuraView, "feed.json")}
  end

  @doc "Provides single feed json render clause for kamakura feeds"
  def render("feed.json", %{kamakura: feed}) do
    %{
      occupants: "#{feed.driver} - #{feed.passenger}",
      created_at: feed.created_at,
      car: feed.car
    }
  end
end
