defmodule KiteConnect.State do
  use GenServer

  ## API
  def start_link do
    state = %{
      api_key: nil,
      api_secret: nil,
      access_token: nil,
    }

    GenServer.start_link(__MODULE__, state, name: __MODULE__)
  end

  def get(k) do
    GenServer.call(__MODULE__, {:val, k})
  end

  def set(k, v) do
    GenServer.cast(__MODULE__, {:set, k, v})
  end

  # Implementation
  @impl true
  def init(state) do
    {:ok, state}
  end

  @impl true
  def handle_call({:val, k}, _from, state) do
    {:reply, Map.get(state, k), state}
  end

  @impl true
  def handle_cast({:set, k, v}, state) do
    {:noreply, Map.replace(state, k, v)}
  end
end
