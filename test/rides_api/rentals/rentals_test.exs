defmodule RidesApi.RentalsTest do
  use RidesApi.DataCase

  alias RidesApi.Rentals

  describe "feeds" do
    alias RidesApi.Rentals.Feed

    @valid_attrs %{car: "some car", created_at: 42, driver: "some driver", passenger: "some passenger"}
    @update_attrs %{car: "some updated car", created_at: 43, driver: "some updated driver", passenger: "some updated passenger"}
    @invalid_attrs %{car: nil, created_at: nil, driver: nil, passenger: nil}

    def feed_fixture(attrs \\ %{}) do
      {:ok, feed} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Rentals.create_feed()

      feed
    end

    test "list_feeds/0 returns all feeds" do
      feed = feed_fixture()
      assert Rentals.list_feeds() == [feed]
    end

    test "get_feed!/1 returns the feed with given id" do
      feed = feed_fixture()
      assert Rentals.get_feed!(feed.id) == feed
    end

    test "create_feed/1 with valid data creates a feed" do
      assert {:ok, %Feed{} = feed} = Rentals.create_feed(@valid_attrs)
      assert feed.car == "some car"
      assert feed.created_at == 42
      assert feed.driver == "some driver"
      assert feed.passenger == "some passenger"
    end

    test "create_feed/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Rentals.create_feed(@invalid_attrs)
    end

    test "update_feed/2 with valid data updates the feed" do
      feed = feed_fixture()
      assert {:ok, feed} = Rentals.update_feed(feed, @update_attrs)
      assert %Feed{} = feed
      assert feed.car == "some updated car"
      assert feed.created_at == 43
      assert feed.driver == "some updated driver"
      assert feed.passenger == "some updated passenger"
    end

    test "update_feed/2 with invalid data returns error changeset" do
      feed = feed_fixture()
      assert {:error, %Ecto.Changeset{}} = Rentals.update_feed(feed, @invalid_attrs)
      assert feed == Rentals.get_feed!(feed.id)
    end

    test "delete_feed/1 deletes the feed" do
      feed = feed_fixture()
      assert {:ok, %Feed{}} = Rentals.delete_feed(feed)
      assert_raise Ecto.NoResultsError, fn -> Rentals.get_feed!(feed.id) end
    end

    test "change_feed/1 returns a feed changeset" do
      feed = feed_fixture()
      assert %Ecto.Changeset{} = Rentals.change_feed(feed)
    end
  end
end
