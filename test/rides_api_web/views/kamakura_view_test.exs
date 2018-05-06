defmodule RidesApiWeb.KamakuraViewTest do
  use RidesApiWeb.ConnCase, async: true

  # Bring render/3 and render_to_string/3 for testing custom views
  import Phoenix.View

  alias RidesApi.Shares.Feed
  alias RidesApiWeb.KamakuraView

  @valid_attrs1 %Feed{
    car: "some blue car",
    created_at: 42,
    driver: "some skinny driver",
    passenger: "some hungry passenger",
    type: "some type"
  }

  @valid_attrs2 %Feed{
    car: "some orange car",
    created_at: 1423,
    driver: "some tall driver",
    passenger: "some quiet passenger",
    type: "some new type"
  }

  test "renders index.json", %{conn: conn} do
    feeds = [@valid_attrs1, @valid_attrs2]
    content = render_to_string(KamakuraView, "index.json", conn: conn, kamakura: feeds)

    assert String.contains?(content, "rides")

    for f <- feeds do
      assert String.contains?(content, "car")
      assert String.contains?(content, f.car)
      assert String.contains?(content, "created_at")
      # assert String.contains?(content, f.created_at) # value is not a string
      assert String.contains?(content, "occupants")
      assert String.contains?(content, f.driver)
      assert String.contains?(content, f.passenger)
      assert String.contains?(content, "#{f.driver} - #{f.passenger}")
    end
  end
end
