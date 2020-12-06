defmodule Conduit.Supervisor do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  def start(_type, _args) do
    children = [
      # Start the Ecto repository
      Conduit.Repo,
      # Start the Telemetry supervisor
      ConduitWeb.Telemetry,
      # Start the PubSub system
      {Phoenix.PubSub, name: Conduit.PubSub},
      # Start the Endpoint (http/https)
      ConduitWeb.Endpoint,
      # Start the commanded application
      Conduit.Application,
      # Start the accounts context
      Conduit.Accounts.Supervisor,
      # Start the blog context
      Conduit.Blog.Supervisor,
      # Uniqueness middleware helper
      Conduit.Support.UniquenessCache,
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Conduit.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  def config_change(changed, _new, removed) do
    ConduitWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
