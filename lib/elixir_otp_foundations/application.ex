defmodule ElixirOtpFoundations.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    # TODO: In Step 5, you will change this to start your Supervisor.
    # children = [
    #   ElixirOtpFoundations.Supervisor
    # ]
    children = []

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: ElixirOtpFoundations.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
