defmodule RidesApiWeb.KamakuraController do
  use RidesApiWeb, :controller

  alias RidesApi.Shares
  alias RidesApiWeb.ControllerHelper, as: Helper

  @key :kamakura
  @action_fallback RidesApiWeb.FallbackController

  def index(conn, _params) do
    case Helper.simulate_busy() do
      false ->
        feeds = Shares.list_feeds(@key)
        render(conn, "index.json", kamakura: feeds)

      true ->
        Helper.server_busy_error(conn)
    end
  end
end
