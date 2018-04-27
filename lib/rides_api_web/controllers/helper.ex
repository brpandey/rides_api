defmodule RidesApiWeb.ControllerHelper do
  use RidesApiWeb, :controller

  @busy_threshhold 7

  def simulate_busy() do
    vector = Stream.cycle([false]) |> Enum.take(@busy_threshhold)
    vector = vector ++ [true]

    [busy] = Enum.shuffle(vector) |> Enum.take(1)
    busy
  end

  def client_error(conn) do
    conn
    |> put_status(400)
    |> put_view(RidesApiWeb.ErrorView)
    |> render("400.json")
  end

  def server_busy_error(conn) do
    conn
    |> put_status(503)
    |> put_view(RidesApiWeb.ErrorView)
    |> render("503.json")
  end
end
