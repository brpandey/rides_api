defmodule RidesApiWeb.GinzaControllerTest do
  use RidesApiWeb.ConnCase
  alias RidesApi.Test.Helper

  # http status codes
  @code_resource_unavailable 503
  @code_client_error 400
  @code_success 200

  @dummy_valid_timestamp 10000
  @dummy_invalid_timestamp :hello

  setup %{conn: conn} do
    # Insert data so we have something meaningful in our tests
    Helper.insert(:seeds)

    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all feeds", %{conn: conn} do
      conn = get(conn, ginza_path(conn, :index))

      case conn.status do
        @code_resource_unavailable ->
          assert %{"error" => "Service temporarily unavailable"} =
                   json_response(conn, @code_resource_unavailable)

        @code_success ->
          assert [%{"car" => _c, "created_at" => _ca, "driver" => _d, "passenger" => _p} | _t] =
                   json_response(conn, @code_success)["rides"]
      end
    end

    test "lists all feeds with correct timestamp parameter", %{conn: conn} do
      conn = get(conn, ginza_path(conn, :index, %{last_checked_at: @dummy_valid_timestamp}))

      case conn.status do
        @code_resource_unavailable ->
          assert %{"error" => "Service temporarily unavailable"} =
                   json_response(conn, @code_resource_unavailable)

        @code_success ->
          assert [%{"car" => _c, "created_at" => _ca, "driver" => _d, "passenger" => _p} | _t] =
                   json_response(conn, @code_success)["rides"]
      end
    end

    test "lists all feeds with incorrect timestamp parameter", %{conn: conn} do
      conn = get(conn, ginza_path(conn, :index, %{last_checked_at: @dummy_invalid_timestamp}))

      case conn.status do
        @code_resource_unavailable ->
          assert %{"error" => "Service temporarily unavailable"} =
                   json_response(conn, @code_resource_unavailable)

        @code_client_error ->
          assert %{"error" => "Query parameters invalid"} =
                   json_response(conn, @code_client_error)
      end
    end
  end
end
