defmodule ElixirOtpFoundations.KVStore do
  @moduledoc """
  A GenServer that acts as a simple in-memory Key-Value store.
  """
  use GenServer

  # ====================================================================
  # Client API
  # 
  # These are the public functions that other processes will call.
  # They are responsible for sending a message to the GenServer process.
  # ====================================================================

  @doc """Starts the KVStore GenServer."""
  def start_link(_opts) do
    # TODO: Start the GenServer. The first argument is this module, the second is
    # the initial state (an empty map), and the third is a name for the process.
    # Using a name makes it easy to find the process later.
    GenServer.start_link(__MODULE__, %{}, name: __MODULE__)
  end

  @doc """Gets a value from the store by key."""
  def get(key) do
    # TODO: Make a synchronous `call` to the GenServer process (identified by its name).
    # The message should be a tuple like `{:get, key}`.
    GenServer.call(__MODULE__, {:get, key})
  end

  @doc """Puts a value into the store."""
  def put(key, value) do
    # TODO: Make an asynchronous `cast` to the GenServer process.
    # The message should be a tuple like `{:put, key, value}`.
    GenServer.cast(__MODULE__, {:put, key, value})
  end

  # ====================================================================
  # Server Callbacks
  #
  # These are the functions that OTP calls inside the GenServer process.
  # You should NEVER call these functions directly.
  # ====================================================================

  @impl true
  def init(initial_state) do
    # The initial state is passed from start_link. Here, it's an empty map.
    {:ok, initial_state}
  end

  @impl true
  def handle_call({:get, key}, _from, state) do
    # TODO: Handle the `:get` message.
    # 1. Look up the `key` in the `state` map.
    # 2. Return a reply tuple: `{:reply, found_value, new_state}`.
    # The state is unchanged in a get operation.
    value = Map.get(state, key)
    {:reply, value, state}
  end

  @impl true
  def handle_cast({:put, key, value}, state) do
    # TODO: Handle the `:put` message.
    # 1. Create a new state map by putting the new key/value into the existing state.
    # 2. Return a noreply tuple: `{:noreply, new_state}`.
    new_state = Map.put(state, key, value)
    {:noreply, new_state}
  end
end
