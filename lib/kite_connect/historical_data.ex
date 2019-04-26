defmodule KiteConnect.HistoricalData do
  @moduledoc """
  Zerodha Kite API for Candlestick Historical Data
  """

  @doc """
  from_dt = Timex.to_datetime({{2018, 11, 1}, {9, 30, 0}}, "Asia/Kolkata")
  to_dt = Timex.to_datetime({{2018, 11, 1}, {9, 35, 0}}, "Asia/Kolkata")

  KiteConnect.HistoricalData.get(5633, "minute", from_dt, to_dt)
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
