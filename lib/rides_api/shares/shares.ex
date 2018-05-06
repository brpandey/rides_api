defmodule RidesApi.Shares do
  @moduledoc """
  The car ride shares context.

  Serves as an aggregate that contains know-how
  in bundling the feed, person and car data together

  Uses the "pull" systems metaphor to generate data on demand 
  and avoid overproduction
  """

  import Ecto.Query, warn: false
  alias RidesApi.Repo

  alias RidesApi.Shares.{Feed, Person, Car}

  @first 1
  @min_persons 2
  @pull_max_feeds 3
  @records_limit 100
  @providers [:ginza, :kamakura]

  @doc """
  Creates a feed.

  ## Examples

      iex> create_feed(%{field: value})
      {:ok, %Feed{}}

      iex> create_feed(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_feed(attrs \\ %{}) do
    %Feed{}
    |> Feed.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Returns the list of feeds.

  ## Examples

      iex> list_feeds()
      [%Feed{}, ...]

  """
  def list_feeds do
    Repo.all(Feed)
  end

  @doc """
  Returns the list of feeds for a given provider.
  """
  def list_feeds(provider) when provider in @providers do
    # When we are given a request to the feeds list
    # We pull and generate new feeds while also
    # returning the current most recent @records_limit 
    # feeds given the provider

    # Generation of new data only happens via accessing the feeds list

    # Pull or create new feeds
    pull_feeds(provider)

    pkey = Atom.to_string(provider)

    Repo.all(
      from(
        f in Feed,
        where: f.type == ^pkey,
        order_by: [desc: :created_at],
        limit: @records_limit
      )
    )
  end

  @doc """
  Returns the list of feeds for a given provider on and after
  a given seconds timestamp.
  """
  def list_feeds(provider, last_checked_at)
      when provider in @providers and is_integer(last_checked_at) do
    # When we are given a request to the feeds list
    # We pull and generate new feeds while also
    # returning the current most recent @records_limit 
    # feeds given the provider and last_checked_at

    # Pull or create new feeds
    pull_feeds(provider)

    pkey = Atom.to_string(provider)

    # Grab the feeds after a certain time
    Repo.all(
      from(
        f in Feed,
        where: f.type == ^pkey,
        where: f.created_at >= ^last_checked_at,
        order_by: [desc: :created_at],
        limit: @records_limit
      )
    )
  end

  @doc """
  Pull a small random number of feeds each time
  to simulate people signing up for a share
  """
  def pull_feeds(provider) when is_atom(provider) do
    [size] = Enum.shuffle(@first..@pull_max_feeds) |> Enum.take(@first)

    for _n <- @first..size, do: pull_feed_and_store(provider)
  end

  @doc """
  Pull a single feed, randomly share it amongst other providers
  to provider some overlap, and then persist
  """
  def pull_feed_and_store(provider) when is_atom(provider) do
    # Lets pull the feed
    attrs = pull_feed()

    providers_list = spread_feed(provider)

    # Given the generated providers list persist the feed for each provider
    Enum.each(providers_list, fn p ->
      # Convert to string
      pkey = Atom.to_string(p)

      # Add the provider key
      attrs = Map.put(attrs, :type, pkey)

      # Write feed to db
      {:ok, %Feed{}} = create_feed(attrs)
    end)
  end

  @doc "Pull or create feed using random entries from the Person and Car tables"
  def pull_feed do
    [%Person{name: driver}, %Person{name: passenger}] = Person.randoms(@min_persons)

    %Car{name: car_name} = Car.random()

    time = :os.system_time(:seconds)

    %{driver: driver, passenger: passenger, car: car_name, created_at: time}
  end

  @doc """
  Spread the feed out into other providers randomly as well -- 
  Make it appear that the providers have a partial view of the world
  by having partial overlaps
  """
  def spread_feed(provider) do
    # Spread out for other providers
    providers = List.delete(@providers, provider)

    n = Enum.count(providers)

    do_spread_feed(n, providers, provider)
  end

  # Handles the spread provider case with no other provider to share to
  def do_spread_feed(0, _providers, provider) do
    # If we have a list that is zero we don't need to shuffle it
    # add the provider that we deleted since we'll insert it anyways
    [provider]
  end

  # Handles the spread provider case with one other provider to share to
  def do_spread_feed(1, providers, provider) do
    # Lets make a 25% chance that we choose to duplicate
    [flag] = [true, false, false, false] |> Enum.shuffle() |> Enum.take(@first)

    case flag do
      true -> [provider] ++ providers
      false -> [provider]
    end
  end

  # Handles the unimplemented generic spread provider case
  def do_spread_feed(n, _providers, _provider) when n > 1 do
    raise ArgumentError, message: "Providers more than 2 is not implemented yet"
  end
end
