defmodule RidesApi.SharesTest do
  use RidesApi.DataCase

  alias RidesApi.Shares
  alias RidesApi.Shares.Feed
  alias RidesApi.Test.Helper

  @ginza :ginza
  @kamakura :kamakura

  describe "feeds" do
    alias RidesApi.Shares.Feed

    @valid_attrs %{
      car: "some car",
      created_at: 42,
      driver: "some driver",
      passenger: "some passenger",
      type: "some type"
    }

    @invalid_attrs %{car: nil, created_at: nil, driver: nil, passenger: nil}

    def feed_fixture(attrs \\ %{}) do
      {:ok, feed} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Shares.create_feed()

      feed
    end

    test "list_feeds/0 returns all feeds one of them is the newly created feed" do
      feed = feed_fixture()
      list = Shares.list_feeds()
      assert Enum.member?(list, feed)
    end

    test "create_feed/1 with valid data creates a feed" do
      assert {:ok, %Feed{} = feed} = Shares.create_feed(@valid_attrs)
      assert feed.car == "some car"
      assert feed.created_at == 42
      assert feed.driver == "some driver"
      assert feed.passenger == "some passenger"
      assert feed.type == "some type"
    end

    test "create_feed/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Shares.create_feed(@invalid_attrs)
    end
  end

  describe "feeds overlap" do
    setup :setup_overlaps

    test "ensure feeds overlap from different providers" do
      IO.puts("waka3")

      # Pull feeds for ginza and kamakura and filter out the non-essentials 
      # For example: id, updated at, inserted_at etc..
      gfeeds = Shares.list_feeds(@ginza) |> filter_helper
      kfeeds = Shares.list_feeds(@kamakura) |> filter_helper

      # Create a mapset
      ms = MapSet.new(gfeeds)

      # Take the smaller collection and iterate through to see if it is a duplicate 
      # member of the ginza feeds data
      flag = Enum.any?(kfeeds, fn f -> MapSet.member?(ms, f) end)

      assert true == flag
    end
  end

  defp setup_overlaps(_context) do
    # Insert test data
    Helper.insert(:all)

    # Pull feeds for ginza multiple times to ensure we've generated
    # some duplicates

    # While we generate the feeds for a provider it should be randomly
    # inserted for other providers as well

    # A limit of 15 generations should ensure there were some duplicates
    for _n <- 1..15 do
      _ = Shares.list_feeds(@ginza)
    end

    :ok
  end

  # Converts from list of feeds to a list of filtered maps with only the essential data to compare
  defp filter_helper([%Feed{} | _t] = list) do
    Enum.map(list, fn %Feed{} = f ->
      %{car: f.car, driver: f.driver, passenger: f.passenger, created_at: f.created_at}
    end)
  end
end
