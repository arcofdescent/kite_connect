defmodule KiteConnect do
  @moduledoc """
  KiteConnect module containing constants, common functionality and others
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

  @api_key Application.get_env(:argus, :kite_api_key)
  @api_secret Application.get_env(:argus, :kite_api_secret)

  def gen_url(module, a1 \\ "", a2 \\ "") do
    api_endpoint = Application.get_env(:argus, :kite_api_endpoint)

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
      Authorization: "token #{@api_key}:#{KiteConnect.AccessToken.get()}"
    ]
  end

  def gen_headers_post do
    [
     "Content-Type": "application/x-www-form-urlencoded",
      "X-Kite-Version": 3,
      Authorization: "token #{@api_key}:#{KiteConnect.AccessToken.get()}"
    ]
  end

  def set_access_token(request_token) do
    {:ok, at} = gen_access_token(request_token)
    KiteConnect.AccessToken.set(at)
  end
  
  defp gen_access_token(request_token) do
    checksum =
      Base.encode16(
        :crypto.hash(
          :sha256,
          "#{@api_key}#{request_token}#{@api_secret}"
        )
      )
      |> String.downcase()

    url = KiteConnect.gen_url("session.token")
    headers = ["X-Kite-Version": 3, "Content-Type": "application/x-www-form-urlencoded"]

    body =
      %{"api_key" => @api_key, "request_token" => request_token, "checksum" => checksum}
      |> URI.encode_query()

    res_body = KiteConnect.HTTP.post(url, body, headers)
    at = res_body["data"]["access_token"]
    
    cond do
      at != nil -> {:ok, at}
      at == nil -> {:error, nil}
    end
  end
end
