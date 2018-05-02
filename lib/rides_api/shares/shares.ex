defmodule RidesApi.Shares do
  @moduledoc """
  The car ride shares context.
  """

  import Ecto.Query, warn: false
  alias RidesApi.Repo

  alias RidesApi.Shares.{Feed, Person, Car}

  @first 1
  @pull_max_feeds 3

  @providers [:ginza, :kamakura]

  @doc """
  Returns the list of feeds.

  ## Examples

      iex> list_feeds()
      [%Feed{}, ...]

  """
  def list_feeds do
    Repo.all(Feed)
  end

  def list_feeds(provider) when provider in @providers do
    # When we are given a request to the feeds list
    # We pull and generate new feeds while also
    # returning the current set of feeds given the provider

    generate_feeds(provider)

    pkey = Atom.to_string(provider)

    Repo.all(from(f in Feed, where: f.type == ^pkey))
  end

  def list_feeds(provider, last_checked_at)
      when provider in @providers and is_integer(last_checked_at) do
    # When we are given a request to the feeds list
    # We pull and generate new feeds while also
    # returning the current set of feeds given the provider and last_checked_at

    generate_feeds(provider)

    pkey = Atom.to_string(provider)

    # Grab the feeds after a certain time
    Repo.all(
      from(
        f in Feed,
        where: f.type == ^pkey,
        where: f.created_at >= ^last_checked_at
      )
    )
  end

  # Generate a random number of feeds each time
  def generate_feeds(provider) when is_atom(provider) do
    [size] = Enum.shuffle(@first..@pull_max_feeds) |> Enum.take(@first)

    for _n <- @first..size, do: generate_feed_and_store(provider)
  end

  def generate_feed_and_store(provider) when is_atom(provider) do
    # Lets generate the feed
    attrs = generate_feed()

    # spread the feed out into other providers randomly as well -- 
    # so it appears there are overlaps in the providers

    # Spread out for other providers
    providers = List.delete(@providers, provider)

    n = Enum.count(providers)

    providers =
      case n do
        # If we have a list that is zero or one elements we don't need to shuffle it
        0 ->
          # prepend the provider that we deleted since we'll insert it anyways
          [provider]

        1 ->
          # Lets make a 25% chance that we choose to duplicate
          [flag] = [true, false, false, false] |> Enum.shuffle() |> Enum.take(@first)

          if flag do
            [provider] ++ providers
          else
            [provider]
          end

        # Including generic case for posterity
        n when n > 1 ->
          size = Kernel.div(n, 2)
          list = Enum.shuffle(providers) |> Enum.take(size)
          # prepend the provider that we deleted since we'll insert it anyways
          [provider] ++ list
      end

    # Insert feed for current providers and a random collection
    # of providers that is half the size of the providers list
    for p <- providers do
      # Convert to string
      pkey = Atom.to_string(p)

      # Add the provider key
      attrs = Map.put(attrs, :type, pkey)

      # Write feed to db
      {:ok, %Feed{}} = create_feed(attrs)
    end
  end

  @doc "Lets create the feed using random entries from the Person and Model tables"
  def generate_feed do
    [
      %Person{name: driver},
      %Person{name: passenger}
    ] = Repo.all(from(p in Person, order_by: fragment("RANDOM()"), limit: 2))

    %Car{name: car_name} = Repo.one(from(c in Car, order_by: fragment("RANDOM()"), limit: 1))

    time = :os.system_time(:seconds)

    %{driver: driver, passenger: passenger, car: car_name, created_at: time}
  end

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
end
