defmodule KiteConnect.HTTP do
  @moduledoc """
  KiteConnect module which handles the HTTP stuff
  """

  def get(url, headers) do
    {:ok, res} = HTTPoison.get(url, headers)
    res_body = res.body |> Poison.decode!()
  end

  def post(url, body, headers) do
    {:ok, res} = HTTPoison.post(url, body, headers)
    res_body = res.body |> Poison.decode!()
  end
end
