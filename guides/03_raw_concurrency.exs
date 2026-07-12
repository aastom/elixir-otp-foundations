# Step 3: Raw Concurrency Primitives
#
# This script demystifies OTP by showing you the raw building blocks:
# processes, PIDs, `spawn`, `send`, and `receive`.
# A GenServer is just a beautiful abstraction around this simple loop!
#
# To run it: `elixir guides/03_raw_concurrency.exs`

IO.puts "--- Starting Step 3: Raw Concurrency ---"

# --- Spawning a Process ---
#
# `spawn/1` takes a function and runs it in a new, lightweight process.
# It does NOT wait for the function to finish. It returns immediately
# with the Process Identifier, or PID.

# Let's define a simple function that the new process will execute.
looper_function = fn -> 
  IO.puts "New process has started! Now waiting for a message..."
  # The `receive` block is the heart of a manual process.
  # It waits and checks its "mailbox" for incoming messages.
  receive do
    {:greet, name} ->
      IO.puts "Process received a greeting for: #{name}"
    {:add, x, y} ->
      IO.puts "Process received a request to add #{x} and #{y}. Result: #{x + y}"
    _ ->
      IO.puts "Process received an unknown message."
  end
  IO.puts "Process is finishing."
end

# Now, let's spawn it!
looper_pid = spawn(looper_function)

IO.inspect looper_pid, label: "Spawned process PID"

# --- Sending Messages ---
#
# Processes are isolated. They don't share memory. The only way to communicate
# with them is by sending a message using `send/2`.

# Syntax: `send(pid, message)`
# The message can be any Elixir term (atom, tuple, map, etc.).

IO.puts "\nMain process is now sending a message..."
send(looper_pid, {:greet, "World"})

# We need to wait a moment for the other process to receive and print.
Process.sleep(100)

# --- A looping server ---
# The first process finished after one message. That's not very useful.
# A real "server" process needs to loop to handle multiple messages.

recursive_server_function = fn ->
  # We need a way to refer to our own function to call it again.
  # We pass it to itself as an argument.
  loop = fn self ->
    receive do
      {:ping, sender_pid} ->
        send(sender_pid, {:pong, self.()})
        self.(self)
      :stop ->
        IO.puts "Server process received stop signal. Shutting down."
      _ ->
        IO.puts "Server process received an unknown message. Still running."
        self.(self)
    end
  end
  loop.(loop)
end

IO.puts "\n--- Starting a looping server process ---"
server_pid = spawn(recursive_server_function)

# Let's test it. We'll send a :ping message. The message needs to include
# our own PID (`self()`) so the server knows where to send the reply!

IO.puts "Pinging the server..."
send(server_pid, {:ping, self()})

# Now we wait for the response.
receive do
  {:pong, pid} ->
    IO.inspect pid, label: "Received a pong from"
 after 500 ->
   IO.puts "No pong received."
end

# Finally, let's tell the server to stop.
send(server_pid, :stop)
Process.sleep(100)

IO.puts "\nThis simple loop (`receive -> do work -> recurse`) is the fundamental pattern that GenServer standardizes."
IO.puts "--- Finished Step 3 ---"
