defmodule RidesApiWeb.KamakuraControllerTest do
  use RidesApiWeb.ConnCase
  alias RidesApi.Test.Helper

  # http status codes
  @code_resource_unavailable 503
  @code_success 200

  #  setup_all do
  #    :ok = Ecto.Adapters.SQL.Sandbox.checkout(RidesApi.Repo)
  #    # Run seeds so we have something meaningful in our tests
  #    Mix.Tasks.Run.run(["priv/repo/seeds.exs"])

  #    on_exit(fn ->
  #      :ok = Ecto.Adapters.SQL.Sandbox.checkout(RidesApi.Repo)

  #      Helper.delete_db_data(:all)
  #    end)
  #  end

  setup %{conn: conn} do
    Helper.insert(:all)
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all feeds", %{conn: conn} do
      conn = get(conn, kamakura_path(conn, :index))

      case conn.status do
        @code_resource_unavailable ->
          assert %{"error" => "Service temporarily unavailable"} =
                   json_response(conn, @code_resource_unavailable)

        @code_success ->
          assert [%{"car" => _c, "created_at" => _ca, "occupants" => _o} | _t] =
                   json_response(conn, @code_success)["rides"]
      end
    end
  end
end
