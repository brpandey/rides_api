defmodule RidesApiWeb.KamakuraController do
  use RidesApiWeb, :controller

  alias RidesApi.Rentals
  alias RidesApiWeb.ControllerHelper, as: Helper

  @key :kamakura
  @action_fallback RidesApiWeb.FallbackController

  def index(conn, _params) do
    case Helper.simulate_busy() do
      false ->
        feeds = Rentals.list_feeds(@key)
        render(conn, "index.json", kamakura: feeds)

      true ->
        Helper.server_busy_error(conn)
    end
  end

  _ = """

  def create(conn, %{"feed" => feed_params}) do
    with {:ok, %Feed{} = feed} <- Rentals.create_feed(feed_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", feed_path(conn, :show, feed))
      |> render("show.json", feed: feed)
    end
  end

  def show(conn, %{"id" => id}) do
    feed = Rentals.get_feed!(id)
    render(conn, "show.json", feed: feed)
  end

  def update(conn, %{"id" => id, "feed" => feed_params}) do
    feed = Rentals.get_feed!(id)

    with {:ok, %Feed{} = feed} <- Rentals.update_feed(feed, feed_params) do
      render(conn, "show.json", feed: feed)
    end
  end

  def delete(conn, %{"id" => id}) do
    feed = Rentals.get_feed!(id)
    with {:ok, %Feed{}} <- Rentals.delete_feed(feed) do
      send_resp(conn, :no_content, "")
    end
  end

  """
end
