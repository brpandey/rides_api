defmodule RidesApiWeb.FeedControllerTest do
  use RidesApiWeb.ConnCase

  alias RidesApi.Rentals
  alias RidesApi.Rentals.Feed

  @create_attrs %{car: "some car", created_at: 42, driver: "some driver", passenger: "some passenger"}
  @update_attrs %{car: "some updated car", created_at: 43, driver: "some updated driver", passenger: "some updated passenger"}
  @invalid_attrs %{car: nil, created_at: nil, driver: nil, passenger: nil}

  def fixture(:feed) do
    {:ok, feed} = Rentals.create_feed(@create_attrs)
    feed
  end

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all feeds", %{conn: conn} do
      conn = get conn, feed_path(conn, :index)
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create feed" do
    test "renders feed when data is valid", %{conn: conn} do
      conn = post conn, feed_path(conn, :create), feed: @create_attrs
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get conn, feed_path(conn, :show, id)
      assert json_response(conn, 200)["data"] == %{
        "id" => id,
        "car" => "some car",
        "created_at" => 42,
        "driver" => "some driver",
        "passenger" => "some passenger"}
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post conn, feed_path(conn, :create), feed: @invalid_attrs
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update feed" do
    setup [:create_feed]

    test "renders feed when data is valid", %{conn: conn, feed: %Feed{id: id} = feed} do
      conn = put conn, feed_path(conn, :update, feed), feed: @update_attrs
      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get conn, feed_path(conn, :show, id)
      assert json_response(conn, 200)["data"] == %{
        "id" => id,
        "car" => "some updated car",
        "created_at" => 43,
        "driver" => "some updated driver",
        "passenger" => "some updated passenger"}
    end

    test "renders errors when data is invalid", %{conn: conn, feed: feed} do
      conn = put conn, feed_path(conn, :update, feed), feed: @invalid_attrs
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete feed" do
    setup [:create_feed]

    test "deletes chosen feed", %{conn: conn, feed: feed} do
      conn = delete conn, feed_path(conn, :delete, feed)
      assert response(conn, 204)
      assert_error_sent 404, fn ->
        get conn, feed_path(conn, :show, feed)
      end
    end
  end

  defp create_feed(_) do
    feed = fixture(:feed)
    {:ok, feed: feed}
  end
end
