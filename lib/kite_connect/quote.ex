defmodule KiteConnect.Quote do
  @moduledoc """
  Zerodha KiteConnect API for Market Quotes and Instruments
  """

  @doc """
  Get last traded price of instrument(s).
  Instruments can be provided as exchange:tradingsymbol combination
  or use instrument token
  
  KiteConnect.Quote.ltp("NSE:INFY")
  """
  def ltp(instruments) when is_list(instruments) do
    url = KiteConnect.gen_url("quote.ltp", instruments)
    headers = KiteConnect.gen_headers()
    res_body = KiteConnect.HTTP.get(url, headers)

    Enum.map(instruments, fn x -> %{token: x, price: res_body["data"][x]["last_price"]} end)
  end

  def ltp(instrument) when is_integer(instrument) do
    ltp(Integer.to_string(instrument))
  end
        
  def ltp(instrument) when is_binary(instrument) do
    url = KiteConnect.gen_url("quote.ltp", instrument)
    headers = KiteConnect.gen_headers()
    res_body = KiteConnect.HTTP.get(url, headers)
    res_body["data"][instrument]["last_price"]
  end

  @doc """
  Full market quote of instruments
  """
  def market_quote(instrument) when is_integer(instrument) do
    market_quote(Integer.to_string(instrument))
  end
        
  def market_quote(instrument) when is_binary(instrument) do
    url = KiteConnect.gen_url("quote.market", instrument)
    headers = KiteConnect.gen_headers()
    res_body = KiteConnect.HTTP.get(url, headers)
  end

  @doc """
  Get bid/ask for instrument
  """
  def get_bid_ask(instrument) when is_integer(instrument) do
    get_bid_ask(Integer.to_string(instrument))
  end
        
  def get_bid_ask(instrument) when is_binary(instrument) do
    body = market_quote(instrument)
    depth = body["data"][instrument]["depth"]

    {
      :bid, Enum.at(depth["buy"], 0)["price"], 
      :ask, Enum.at(depth["sell"], 0)["price"]
    }
  end
end
