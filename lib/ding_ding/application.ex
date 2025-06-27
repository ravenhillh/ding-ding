defmodule DingDing.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      DingDingWeb.Telemetry,
      DingDing.Repo,
      {DNSCluster, query: Application.get_env(:ding_ding, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: DingDing.PubSub},
      # Start the Finch HTTP client for sending emails
      {Finch, name: DingDing.Finch},
      # Start a worker by calling: DingDing.Worker.start_link(arg)
      # {DingDing.Worker, arg},
      # Start to serve requests, typically the last entry
      DingDingWeb.Endpoint
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: DingDing.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    DingDingWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
