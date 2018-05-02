defmodule RidesApiWeb.GinzaController do
  use RidesApiWeb, :controller

  alias RidesApi.Shares
  alias RidesApiWeb.ControllerHelper, as: Helper

  @key :ginza
  @action_fallback RidesApiWeb.FallbackController

  def index(conn, %{"last_checked_at" => last_checked_at} = _params)
      when is_binary(last_checked_at) do
    case Helper.simulate_busy() do
      false ->
        case Integer.parse(last_checked_at) do
          {num, ""} ->
            feeds = Shares.list_feeds(@key, num)
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
        feeds = Shares.list_feeds(@key)
        render(conn, "index.json", ginza: feeds)

      true ->
        Helper.server_busy_error(conn)
    end
  end
end
