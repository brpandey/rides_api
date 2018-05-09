defmodule RidesApi.ReleaseTasks do
  alias Ecto.Migrator

  # See https://hexdocs.pm/distillery/running-migrations.html

  @otp_app :rides_api
  @start_apps [:logger, :ssl, :postgrex, :ecto]

  def migrate_seed do
    init(@otp_app, @start_apps)

    do_migrate()
    do_seed()

    stop()
  end

  def migrate do
    init(@otp_app, @start_apps)
    do_migrate()
    stop()
  end

  def seed do
    init(@otp_app, @start_apps)
    do_seed()
    stop()
  end

  defp init(app, start_apps) do
    IO.puts("Loading app..")
    :ok = Application.load(app)

    IO.puts("Starting dependencies..")
    Enum.each(start_apps, &Application.ensure_all_started/1)

    IO.puts("Starting repos..")

    list = app |> Application.get_env(:ecto_repos, [])

    Enum.each(list, & &1.start_link(pool_size: 1))
    Enum.each(list, &ensure_repo_created/1)
  end

  defp stop do
    IO.puts("Success!")
    :init.stop()
  end

  defp run_migrations_for(app) do
    IO.puts("Running migrations for #{app}")

    app
    |> Application.get_env(:ecto_repos, [])
    |> Enum.each(&Migrator.run(&1, migrations_path(app), :up, all: true))
  end

  defp run_seed_script(seed_script) do
    IO.puts("Running seed script #{seed_script}..")
    Code.eval_file(seed_script)
  end

  defp migrations_path(app), do: priv_dir(app, ["repo", "migrations"])

  defp seed_path(app), do: priv_dir(app, ["repo", "seeds.exs"])

  defp priv_dir(app, path) when is_list(path) do
    case :code.priv_dir(app) do
      priv_path when is_list(priv_path) or is_binary(priv_path) ->
        Path.join([priv_path] ++ path)

      {:error, :bad_name} ->
        raise ArgumentError, "unknown application: #{inspect(app)}"
    end
  end

  defp ensure_repo_created(repo) do
    case repo.__adapter__.storage_up(repo.config) do
      :ok ->
        IO.puts("Creating DB")
        Process.sleep(2000)
        :ok

      {:error, :already_up} ->
        IO.puts("DB Already up")
        :ok

      {:error, term} ->
        IO.puts("Error Creating DB")
        {:error, term}
    end
  end

  defp do_migrate, do: run_migrations_for(@otp_app)

  defp do_seed do
    # Run the seed script if it exists
    seed_script = seed_path(@otp_app)

    if File.exists?(seed_script) do
      run_seed_script(seed_script)
    end
  end
end
