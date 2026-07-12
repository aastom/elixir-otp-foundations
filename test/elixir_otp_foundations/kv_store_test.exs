defmodule ElixirOtpFoundations.KVStoreTest do
  use ExUnit.Case, async: true

  alias ElixirOtpFoundations.KVStore

  setup do
    # Start a KVStore process linked to the test process.
    # This ensures it gets shut down automatically after the test.
    {:ok, pid} = KVStore.start_link([])
    %{pid: pid}
  end

  test "can get a value after putting it in the store", %{pid: _pid} do
    # The KVStore is started under a name, so we don't need the pid.
    assert KVStore.get(:hello) == nil

    :ok = KVStore.put(:hello, "world")

    assert KVStore.get(:hello) == "world"
  end

  test "can overwrite a value", %{pid: _pid} do
    :ok = KVStore.put(:data, 123)
    assert KVStore.get(:data) == 123

    :ok = KVStore.put(:data, 456)
    assert KVStore.get(:data) == 456
  end

  test "get returns nil for a non-existent key", %{pid: _pid} do
    assert KVStore.get(:nonexistent) == nil
  end
end
