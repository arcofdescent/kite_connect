defmodule KiteConnect.AccessToken do
  use GenServer

  ## API
  def start_link(tk \\ 0) do
    GenServer.start_link(__MODULE__, tk, name: __MODULE__)
  end

  def get do
    GenServer.call(__MODULE__, :val)
  end

  def set(tk) do
    GenServer.cast(__MODULE__, {:set, tk})
  end

  # Implementation
  def init(tk) do
    {:ok, tk}
  end

  def handle_call(:val, _from, curr_tk) do
    {:reply, curr_tk, curr_tk}
  end

  def handle_cast({:set, new_tk}, curr_tk) do
    {:noreply, new_tk}
  end
end
