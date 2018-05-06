defmodule RidesApiWeb.ControllerHelper do
  @moduledoc """
  Provides convenience methods for controllers
  to determine if the server is busy
  as well provides response view helpers
  """

  use RidesApiWeb, :controller

  @first 1
  @busy_threshhold 7

  @doc "We have a 1 in 8 chance that the server is simulated busy"
  def simulate_busy() do
    vector = Stream.cycle([false]) |> Enum.take(@busy_threshhold)
    vector = vector ++ [true]

    [busy] = Enum.shuffle(vector) |> Enum.take(@first)
    busy
  end

  @doc "Sets response info around a client error"
  def client_error(conn) do
    conn
    |> put_status(400)
    |> put_view(RidesApiWeb.ErrorView)
    |> render("400.json")
  end

  @doc "Sets response info around a server unavailable error"
  def server_busy_error(conn) do
    conn
    |> put_status(503)
    |> put_view(RidesApiWeb.ErrorView)
    |> render("503.json")
  end
end
