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
iex(1)> KiteConnect.init(your_api_key, your_api_secret)
:ok
iex(2)> KiteConnect.set_access_token(your_request_token)
:ok
iex(3)> KiteConnect.Quote.ltp("NSE:INFY")
724.3
```
