defmodule Cache do
  use GenServer

  @name GenCache

  def start_link(opts \\ []) do
    GenServer.start_link(__MODULE__, :ok, [name: @name] ++ opts)
  end

  def write(key, value) do
    GenServer.cast(@name, {:write, {key, value}})
  end

  def read(key) do
    GenServer.call(@name, {:read, key})
  end

  def delete(key) do
    GenServer.cast(@name, {:delete, key})
  end

  def clear do
    GenServer.cast(@name, :clear)
  end

  def exist?(key) do
    GenServer.call(@name, {:exist, key})
  end

  def key_count do
    GenServer.call(@name, :key_count)
  end

  def stop do
    GenServer.cast(@name, :stop)
  end

  ## Server Callbacks

  def init(:ok) do
    {:ok, %{}}
  end

  def handle_call({:read, key}, _from, cache) do
    case Map.fetch(cache, key) do
      {:ok, value} ->
        {:reply, value, cache}
      :error ->
        {:reply, {:error, :no_value}, cache}
    end
  end

  def handle_call({:exist, key}, _from, cache) do
    {:reply, Map.has_key?(cache, key), cache}
  end

  def handle_call(:key_count, _from, cache) do
    {:reply, Map.keys(cache) |> length, cache}
  end

  def handle_cast({:write, {key, value}}, cache) do
    {:noreply, Map.put(cache, key, value)}
  end

  def handle_cast({:delete, key}, cache) do
    {:noreply, Map.delete(cache, key)}
  end

  def handle_cast(:clear, _cache), do: {:noreply, %{}}

  def handle_cast(:stop, cache) do
    {:stop, :normal, cache}
  end

  def handle_info(msg, cache) do
    IO.puts "received unhandled message: #{inspect msg}"
    {:noreply, cache}
  end

  def terminate(reason, cache) do
    key_count = Map.keys(cache) |> length
    IO.puts "terminating cache for reason: #{inspect reason}"
    IO.puts "cache terminated with #{key_count} keys"
    :ok
  end
end
