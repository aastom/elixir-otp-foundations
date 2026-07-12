# Step 1: Basic Syntax, Data Types, and Immutability
#
# Welcome to Elixir! This script covers the foundational concepts.
# To run it, open your terminal and execute: `elixir guides/01_basics_and_immutability.exs`

IO.puts "--- Starting Step 1: Basics & Immutability ---"

# --- Basic Data Types ---

# An atom is a constant whose name is its own value. Think of them like symbols.
:ok
:error
:my_custom_atom

# Tuples store a fixed number of items. They are often used for returning
# multiple values from a function, like a status and a result.
status_tuple = {:ok, "Data fetched successfully"}
IO.inspect status_tuple, label: "A status tuple"

# Lists are linked lists, great for recursion.
numbers = [1, 2, 3, 4, 5]
IO.inspect numbers, label: "A list of numbers"

# Maps are the go-to key-value store.
user_map = %{name: "Alex", language: "Elixir", score: 100}
IO.inspect user_map, label: "A user map"

# You access map values using dot-notation for atom keys or bracket-notation for any key.
IO.inspect user_map.name, label: "Accessing user name with .name"
IO.inspect user_map[:language], label: "Accessing language with [:language]"

# --- Immutability: The Core Principle ---

# In Elixir, data is immutable. You don't change data; you create new data.
original_list = [1, 2, 3]

# Let's try to "add" an item to the list.
new_list = [0 | original_list]

IO.inspect original_list, label: "The original list is UNCHANGED"
IO.inspect new_list, label: "The new list is a NEW data structure"

# The same is true for maps.
user = %{name: "Maria"}
# `Map.put` returns a NEW map with the key added.
updated_user = Map.put(user, :role, "developer")

IO.inspect user, label: "Original user map"
IO.inspect updated_user, label: "The updated user is a NEW map"

# --- Pattern Matching: More Than Variable Assignment ---

# Pattern matching uses the `=` operator, but it's not assignment. It's an assertion.
# If the pattern on the left matches the value on the right, the variables are bound.
{:ok, message} = {:ok, "This is a message"}
IO.inspect message, label: "Pattern matched message"

# This is incredibly powerful for destructuring data.
[%{name: name} | _rest] = [%{name: "Alice"}, %{name: "Bob"}]
IO.inspect name, label: "Pattern matched name from a list of maps"

# It also works in function heads.

# --- Functions, Guards, and Multi-Clause Functions ---

defmodule Greeter do
  # This function clause only matches when the `name` is "Admin".
  def greet("Admin"), do: "Welcome back, Admin!"

  # This clause has a "guard" (`when is_binary(name)`), meaning it will only
  # execute if `name` is a string. `is_binary` is Elixir's way to check for strings.
  def greet(name) when is_binary(name) do
    "Hello, #{name}."
  end

  # This is a fallback clause if no others match.
  def greet(_), do: "Invalid greeting target."
end

IO.puts Greeter.greet("Admin") # Matches the first clause
IO.puts Greeter.greet("User")  # Matches the second clause (with the guard)
IO.puts Greeter.greet(123)     # Matches the final fallback clause

# --- Key Exercise: Recursive List Manipulation ---
# The best way to internalize the functional mindset is to implement common
# list operations using recursion and pattern matching.

defmodule MyListUtils do
  # Our own map function.
  # Base case: an empty list maps to an empty list.
  def map([], _func), do: []

  # Recursive case: apply the function to the head, and recurse on the tail.
  def map([head | tail], func) do
    [func.(head) | map(tail, func)]
  end

  # Our own filter function.
  # Base case: an empty list filters to an empty list.
  def filter([], _predicate), do: []

  # Recursive case 1: If the predicate is true for the head, keep it.
  def filter([head | tail], predicate) when predicate.(head) do
    [head | filter(tail, predicate)]
  end

  # Recursive case 2: If the predicate is false, discard the head.
  def filter([_head | tail], predicate) do
    filter(tail, predicate)
  end
end

numbers_to_transform = [1, 2, 3, 4]

# EXERCISE: Use the MyListUtils functions to:
# 1. Double each number in `numbers_to_transform`
# 2. Filter the original list to keep only even numbers.

doubled = MyListUtils.map(numbers_to_transform, fn x -> x * 2 end)
IO.inspect doubled, label: "Doubled numbers"

evens = MyListUtils.filter(numbers_to_transform, fn x -> rem(x, 2) == 0 end)
IO.inspect evens, label: "Filtered even numbers"

IO.puts "--- Finished Step 1 ---"
