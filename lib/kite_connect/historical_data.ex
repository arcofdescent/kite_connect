defmodule KiteConnect.HistoricalData do
  @moduledoc """
  Zerodha Kite API for Candlestick Historical Data
  """

  @doc """
  instrument_token = 5633
  interval = "minute"
  
  Possible values are:
  · minute
  · day
  · 3minute
  · 5minute
  · 10minute
  · 15minute
  · 30minute
  · 60minute

  from_dt = "2019-04-01 10:00"
  to_dt = "2019-04-01 10:15"

  KiteConnect.HistoricalData.get(instrument_token, interval, from_dt, to_dt)
  """

  def get(instrument_token, interval, from, to) do
    url = KiteConnect.gen_url("instruments.historical", instrument_token, interval)
    headers = KiteConnect.gen_headers()

    {:ok, from_dt} = Timex.format(from, "%Y-%m-%d+%H:%M:%S", :strftime)
    {:ok, to_dt} = Timex.format(to, "%Y-%m-%d+%H:%M:%S", :strftime)

    url = url <> "?from=#{from_dt}&to=#{to_dt}"
    res_body = KiteConnect.HTTP.get(url, headers)
    res_body["data"]["candles"]
  end
end
