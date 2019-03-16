defmodule KiteConnectTest do
  use ExUnit.Case

  test "gen_url" do
    assert KiteConnect.gen_url("quote.ltp", "NSE:INFY") == "https://api.kite.trade/quote/ltp?i=NSE:INFY"
    assert KiteConnect.gen_url("session.token") == "https://api.kite.trade/session/token"

    assert KiteConnect.gen_url("instruments.historical", "NSE:INFY", "minute") ==
             "https://api.kite.trade/instruments/historical/NSE:INFY/minute"
  end
end
