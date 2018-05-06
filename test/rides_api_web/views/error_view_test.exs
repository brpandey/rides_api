defmodule RidesApiWeb.ErrorViewTest do
  use ExUnit.Case, async: true

  # Bring render/3 and render_to_string/3 for testing custom views
  import Phoenix.View

  test "renders 400.json" do
    assert render(RidesApiWeb.ErrorView, "400.json", []) == %{error: "Query parameters invalid"}
  end

  test "renders 503.json" do
    assert render(RidesApiWeb.ErrorView, "503.json", []) ==
             %{error: "Service temporarily unavailable"}
  end
end
