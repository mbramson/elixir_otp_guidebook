defmodule LinkRing do
  def create_processes(n) do
    1..n |> Enum.map(fn _ -> spawn(fn -> loop end) end)
  end

  def loop do
    receive do
      {:link, link_to} when is_pid(link_to) ->
        Process.link(link_to)
        loop
      :crash ->
        1/0
    end
  end

  def link_processes(processes) do
    link_processes(processes, [])
  end

  def link_processes([process_1, process_2|tail], linked_processes) do
    # link the first process to the second process
    send(process_1, {:link, process_2})
    link_processes([process_2|tail], [process_1|linked_processes])
  end

  def link_processes([process|[]], linked_processes) do
    # link the last process to the first process
    first_process = linked_processes |> List.last
    send(process, {:link, first_process})
    :ok
  end

  def print_links(pids) do
    pids
    |> Enum.map(&"#{inspect &1}: #{inspect Process.info(&1, :links)}")
  end

  def print_alive(pids) do
    pids
    |> Enum.map(&"#{inspect &1}: #{inspect Process.alive?(&1)}")
  end

  def crash_random_process(pids) do
    pids |> Enum.shuffle |> List.first |> send(:crash)
  end
end
