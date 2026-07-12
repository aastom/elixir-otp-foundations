# Key OTP Concepts Explained

This document clarifies some of the most powerful—and initially confusing—concepts in OTP. Refer back to this as you work through the `lib/` implementation.

## 1. The GenServer Divide: Client API vs. Server Callbacks

A `GenServer` is a single process that runs a loop, but you interact with it through two distinct sets of functions. Understanding this separation is critical.

*   **The Client API:** These are the public-facing functions you define in your module and call from other parts of your application (or an `iex` session). They are the entry point.
*   **The Server Callbacks:** These are the functions that OTP calls *for you* inside the GenServer's process. You never call them directly. They handle the messages sent by the Client API.

```mermaid
graph TD
    subgraph Your Application (The "Client")
        A[Your Code: `KVStore.get(pid, :my_key)`] --> B{GenServer Module};
    end

    subgraph " "
        B -- sends message --> C[GenServer Process Mailbox];
    end

    subgraph GenServer Process (The "Server")
        C -- sequential processing --> D{OTP's Internal Loop};
        D -- calls callback --> E[Your Callback: `handle_call(:get, ...)`];
    end

    E -- returns tuple --> D;
    D -- sends reply --> B;
    B -- returns value --> A;

    style A fill:#cde4ff
    style E fill:#cde4ff
```

As the diagram shows:
1.  You call a function in your module (e.g., `KVStore.get/2`).
2.  This function uses `GenServer.call/2` or `GenServer.cast/2` to package your arguments into a message and send it to the `GenServer` process.
3.  The OTP framework receives the message in the process's mailbox.
4.  The framework then invokes the corresponding callback in your module (e.g., `handle_call/3` or `handle_cast/2`), passing the message contents as arguments.
5.  Your callback does the work and returns a special tuple (e.g., `{:reply, value, new_state}`).
6.  The OTP framework sends the `value` back to the original caller.

**You write the functions in blue.** OTP does the rest.

## 2. The Sequential Bottleneck by Design

A single `GenServer` process handles messages **one at a time, in the order they are received**. This is not a flaw; it is its most important feature.

By processing messages sequentially, a `GenServer` provides a safe, controlled environment for managing state. You are guaranteed that no two messages can ever modify the state at the same time. This eliminates a whole class of race conditions that are common in other languages.

If you need high-volume, concurrent *reads*, you might use an ETS table. If you need concurrent *writes*, you might need multiple GenServers. But for controlled, transactional state changes, the sequential nature of a `GenServer` is exactly what you want.

## 3. "Where Is My Data?" The Ephemeral State Problem

A `GenServer`'s state is held in the process's memory. It is incredibly fast, but it is also **volatile**.

-   If the `GenServer` process crashes, its state is **gone**.
-   If you restart your entire Elixir application, its state is **gone**.

This is the "ephemeral state trap" you will experience in Step 5 of this learning guide. This is not a mistake in your code; it is a fundamental property of process state.

This leads to two key questions that OTP is designed to answer:

1.  **"How do I recover from a crash?"**
    *   **Answer: A Supervisor.** The Supervisor's job is not to save the state, but to restart the `GenServer` process in a clean, known-good state. This provides *fault tolerance*. You will implement this in Step 5.

2.  **"How do I save my data permanently?"**
    *   **Answer: Persistence.** This is the next step beyond this introductory project. You would use tools like Erlang's built-in Term Storage (ETS), a file, or a database to store the data in a durable location. The `GenServer` would then be responsible for reading from and writing to that persistent storage.
