defmodule RidesApiWeb.GinzaController do
  use RidesApiWeb, :controller

  alias RidesApi.Rentals
  alias RidesApiWeb.ControllerHelper, as: Helper

  @key :ginza
  @action_fallback RidesApiWeb.FallbackController

  def index(conn, %{"last_checked_at" => last_checked_at} = _params)
      when is_binary(last_checked_at) do
    case Helper.simulate_busy() do
      false ->
        case Integer.parse(last_checked_at) do
          {num, ""} ->
            feeds = Rentals.list_feeds(@key, num)
            render(conn, "index.json", ginza: feeds)

          {_num, _dec} ->
            Helper.client_error(conn)

          :error ->
            Helper.client_error(conn)
        end

      true ->
        Helper.server_busy_error(conn)
    end
  end

  def index(conn, _params) do
    case Helper.simulate_busy() do
      false ->
        feeds = Rentals.list_feeds(@key)
        render(conn, "index.json", ginza: feeds)

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
