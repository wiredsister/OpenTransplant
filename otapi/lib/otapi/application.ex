defmodule Otapi.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  def start(_type, _args) do
    children = [
      # Start the Telemetry supervisor
      OtapiWeb.Telemetry,
      # Start the PubSub system
      {Phoenix.PubSub, name: Otapi.PubSub},
      # Start the Endpoint (http/https)
      OtapiWeb.Endpoint
      # Start a worker by calling: Otapi.Worker.start_link(arg)
      # {Otapi.Worker, arg}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Otapi.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  def config_change(changed, _new, removed) do
    OtapiWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
