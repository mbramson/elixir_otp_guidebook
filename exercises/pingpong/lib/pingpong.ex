defmodule PingPong do
  def pingpong() do
    ping_pid = spawn(PingPong.Ping, :loop, [])
    pong_pid = spawn(PingPong.Pong, :loop, [])
    %{ping: ping_pid, pong: pong_pid}
  end
end

defmodule PingPong.Ping do
  def loop do
    receive do
      {sender_pid, "ping"} when is_pid(sender_pid) ->
        send(sender_pid, {:ok, "pong"})
      {sender_pid, _} when is_pid(sender_pid) ->
        send(sender_pid, {:error, :not_ping_error})
      _ ->
        IO.puts "PingPong.Ping: I don't know how to respond!"
    end
    loop
  end
end

defmodule PingPong.Pong do
  def loop do
    receive do
      {sender_pid, "pong"} when is_pid(sender_pid) ->
        send(sender_pid, {:ok, "ping"})
      {sender_pid, _} when is_pid(sender_pid) ->
        send(sender_pid, {:error, :not_pong_error})
      _ ->
        IO.puts "PingPong.Pong: I don't know how to respond!"
    end
    loop
  end
end
