defmodule KiteConnect do
  @moduledoc """
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
  """

  @module_map %{
    "quote.ltp" => "quote/ltp",
    "quote.market" => "quote",
    "session.token" => "session/token",
    "user.margins" => "user/margins",
    "instruments.historical" => "instruments/historical",
    "orders.regular" => "orders/regular",
    "orders.bo" => "orders/bo",
    "orders.history" => "orders",
    "orders" => "orders",
  }

  def init(api_key, api_secret) do
    KiteConnect.State.set(:api_key, api_key)
    KiteConnect.State.set(:api_secret, api_secret)
  end
  
  def api_key do
    KiteConnect.State.get(:api_key)
  end
  
  def api_secret do
    KiteConnect.State.get(:api_secret)
  end
  
  def access_token do
    KiteConnect.State.get(:access_token)
  end
  
  def set_access_token(request_token) do
    {:ok, at} = gen_access_token(request_token)
    KiteConnect.State.set(:access_token, at)
  end
  
  def gen_url(module, a1 \\ "", a2 \\ "") do
    api_endpoint = "https://api.kite.trade"

    case module do
      "quote.ltp" ->
        case is_list(a1) do
          true ->
            "#{api_endpoint}/#{@module_map[module]}?i=" <> Enum.join(a1, "&i=")
          false ->
            "#{api_endpoint}/#{@module_map[module]}?i=#{a1}"
        end

      "quote.market" ->
        case is_list(a1) do
          true ->
            "#{api_endpoint}/#{@module_map[module]}?i=" <> Enum.join(a1, "&i=")
          false ->
            "#{api_endpoint}/#{@module_map[module]}?i=#{a1}"
        end

      "instruments.historical" ->
        "#{api_endpoint}/#{@module_map[module]}/#{a1}/#{a2}"

      "orders.history" ->
        "#{api_endpoint}/#{@module_map[module]}/#{a1}"

      _ ->
        "#{api_endpoint}/#{@module_map[module]}"
    end
  end

  def gen_headers do
    [
      "X-Kite-Version": 3,
      Authorization: "token #{KiteConnect.api_key}:#{KiteConnect.access_token}"
    ]
  end

  def gen_headers_post do
    [
     "Content-Type": "application/x-www-form-urlencoded",
      "X-Kite-Version": 3,
      Authorization: "token #{KiteConnect.api_key}:#{KiteConnect.access_token}"
    ]
  end

  defp gen_access_token(request_token) do
    checksum =
      Base.encode16(
        :crypto.hash(
          :sha256,
          "#{KiteConnect.api_key}#{request_token}#{KiteConnect.api_secret}"
        )
      )
      |> String.downcase()

    url = KiteConnect.gen_url("session.token")
    headers = ["X-Kite-Version": 3, "Content-Type": "application/x-www-form-urlencoded"]

    body =
      %{"api_key" => KiteConnect.api_key, "request_token" => request_token, "checksum" => checksum}
      |> URI.encode_query()

    res_body = KiteConnect.HTTP.post(url, body, headers)
    at = res_body["data"]["access_token"]
    
    cond do
      at != nil -> {:ok, at}
      at == nil -> {:error, nil}
    end
  end
end
