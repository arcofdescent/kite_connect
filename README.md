# KiteConnect

Elixir module for the Zerodha Kite Connect API

## Installation

Add `kite_connect` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:kite_connect, "~> 0.1"}
  ]
end
```

## Setup

Your project should be an OTP application. In your `application.ex`
file start `KiteConnect.State` as a worker.

```elixir
 # Define workers and child supervisors to be supervised
    children = [

      # Start your own worker
      worker(KiteConnect.State, []),
    ]

```

A sample iex session:

```
$ iex -S mix
Erlang/OTP 21 [erts-10.2.3] [source] [64-bit] [smp:4:4] [ds:4:4:10] [async-threads:1] [hipe]

Interactive Elixir (1.8.1) - press Ctrl+C to exit (type h() ENTER for help)
```
