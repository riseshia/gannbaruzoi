defmodule Gannbaruzoi.Application do
  @moduledoc """
  Gannbaruzoi Application
  """

  use Application

  alias GannbaruzoiWeb.Endpoint

  # See http://elixir-lang.org/docs/stable/elixir/Application.html
  # for more information on OTP Applications
  def start(_type, _args) do
    import Supervisor.Spec

    # Define workers and child supervisors to be supervised
    children = [
      # Start the Ecto repository
      supervisor(Gannbaruzoi.Repo, []),
      # Start the endpoint when the application starts
      supervisor(GannbaruzoiWeb.Endpoint, []),
      # Start your own worker by calling:
      #   Gannbaruzoi.Worker.start_link(arg1, arg2, arg3)
      #
      # worker(Gannbaruzoi.Worker, [arg1, arg2, arg3]),
      supervisor(Absinthe.Subscription, [GannbaruzoiWeb.Endpoint]),
    ]

    # See http://elixir-lang.org/docs/stable/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Gannbaruzoi.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  def config_change(changed, _new, removed) do
    Endpoint.config_change(changed, removed)
    :ok
  end
end
