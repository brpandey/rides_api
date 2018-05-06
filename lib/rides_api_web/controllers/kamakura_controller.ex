defmodule RidesApiWeb.KamakuraController do
  @moduledoc """
  Implements Kamakura Shares index controller method

  Simulates a randomly busy server while listing feed data
  """

  use RidesApiWeb, :controller

  alias RidesApi.Shares
  alias RidesApiWeb.ControllerHelper, as: Helper

  @key :kamakura
  @action_fallback RidesApiWeb.FallbackController

  @doc "Returns list of kamakura provider feed data"
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
