defmodule ElixirOtpFoundations.Supervisor do
  @moduledoc """
  The top-level Supervisor for the application.
  """
  use Supervisor

  def start_link(init_arg) do
    Supervisor.start_link(__MODULE__, init_arg, name: __MODULE__)
  end

  @impl true
  def init(_init_arg) do
    # TODO: In Step 5, define the child processes.
    # The KVStore should be a "worker".
    # See: https://hexdocs.pm/elixir/Supervisor.html
    children = [
      # {ElixirOtpFoundations.KVStore, []}
    ]

    Supervisor.init(children, strategy: :one_for_one)
  end
end
