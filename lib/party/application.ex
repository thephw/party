defmodule Party.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    Party.Release.migrate()

    children = [
      PartyWeb.Telemetry,
      Party.Repo,
      {Ecto.Migrator,
       repos: Application.fetch_env!(:party, :ecto_repos), skip: skip_migrations?()},
      {DNSCluster, query: Application.get_env(:party, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: Party.PubSub},
      # Start a worker by calling: Party.Worker.start_link(arg)
      # {Party.Worker, arg},
      # Start to serve requests, typically the last entry
      PartyWeb.Endpoint
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Party.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    PartyWeb.Endpoint.config_change(changed, removed)
    :ok
  end

  defp skip_migrations?() do
    # By default, sqlite migrations are run when using a release
    System.get_env("RELEASE_NAME") != nil
  end
end
