defmodule KiteConnect.State do
  use GenServer

  ## API
  def start_link do
    state = %{
      api_key: "xxx",
      api_secret: "yyy",
    }

    GenServer.start_link(__MODULE__, state, name: __MODULE__)
  end

  def get(k) do
    IO.puts "Inside get: #{inspect k}"
    GenServer.call(__MODULE__, {:val, k})
  end

  def set(tk) do
    GenServer.cast(__MODULE__, {:set, tk})
  end

  # Implementation
  @impl true
  def init(state) do
    IO.puts "Inside init: #{inspect state}"
    {:ok, state}
  end

  @impl true
  def handle_call({:val, k}, _from, state) do
    IO.puts "Inside handle_call: #{inspect k}"
    {:reply, Map.get(state, k), state}
  end

  @impl true
  def handle_cast({:set, new_tk}, curr_tk) do
    {:noreply, new_tk}
  end
end
