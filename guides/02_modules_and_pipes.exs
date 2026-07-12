# Step 2: Modules and the Pipe Operator
#
# This script demonstrates how to group functions into modules and
# how to create clean, readable data pipelines with `|>`.
#
# To run it: `elixir guides/02_modules_and_pipes.exs`

IO.puts "--- Starting Step 2: Modules & Pipes ---"

# In Step 1, we defined `MyListUtils`. Let's imagine it's in its own file.
# We can use `import` to bring its functions into the current scope.

# (We'll just redefine it here for the sake of a runnable script)
defmodule MyListUtils do
  def map([], _func), do: []
  def map([head | tail], func), do: [func.(head) | map(tail, func)]

  def filter([], _predicate), do: []
  def filter([head | tail], predicate) when predicate.(head), do: [head | filter(tail, predicate)]
  def filter([_head | tail], predicate), do: filter(tail, predicate)
end

# --- The Problem: Nested Function Calls ---

# Let's say we have a list of numbers and we want to:
# 1. Get the numbers from 1 to 10.
# 2. Keep only the even ones.
# 3. Square them.

numbers = Enum.to_list(1..10)

# Without the pipe operator, you have to nest function calls:
result_nested = MyListUtils.map(
  MyListUtils.filter(numbers, fn x -> rem(x, 2) == 0 end),
  fn x -> x * x end
)

IO.inspect result_nested, label: "Result (Nested)"

# This is hard to read. The operations are performed from the inside out.

# --- The Solution: The Pipe Operator `|>` ---

# The pipe operator `|>` takes the result of the expression on its left
# and inserts it as the FIRST argument to the function call on its right.

# So, `x |> f(y)` is the same as `f(x, y)`.

# Let's rewrite the previous example using pipes:
result_piped = 
  numbers
  |> MyListUtils.filter(fn x -> rem(x, 2) == 0 end)
  |> MyListUtils.map(fn x -> x * x end)

IO.inspect result_piped, label: "Result (Piped)"

# Much better! The code now reads like a series of transformations, top to bottom.
# This is the idiomatic way to write Elixir code.

# --- Key Exercise: Chaining transformations ---

# Let's use a more complex data structure.
data = [
  %{user: "ana", score: 88, country: "USA"},
  %{user: "bob", score: 95, country: "AUS"},
  %{user: "cat", score: 72, country: "USA"}
]

# EXERCISE: Using the pipe operator and functions from the `Enum` module:
# 1. Filter for users from the "USA".
# 2. Extract just their scores.
# 3. Calculate the sum of their scores.

usa_score_sum = 
  data
  |> Enum.filter(fn person -> person.country == "USA" end)
  |> Enum.map(fn person -> person.score end)
  |> Enum.sum()

IO.inspect usa_score_sum, label: "Total score for USA users"

IO.puts "--- Finished Step 2 ---"
