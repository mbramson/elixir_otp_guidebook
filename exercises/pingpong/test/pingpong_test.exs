defmodule PingpongTest do
  use ExUnit.Case

  describe "PingPong.Ping" do
    test "sends pong when it receives ping" do
      %{ping: ping_pid} = PingPong.pingpong()
      send(ping_pid, {self(), "ping"})
      assert_receive {:ok, "pong"}
    end

    test "sends an error when it receives not ping" do
      %{ping: ping_pid} = PingPong.pingpong()
      send(ping_pid, {self(), "pong"})
      assert_receive {:error, :not_ping_error}
    end
  end

  describe "PingPong.Pong" do
    test "sends ping when it receives pong" do
      %{pong: pong_pid} = PingPong.pingpong()
      send(pong_pid, {self(), "pong"})
      assert_receive {:ok, "ping"}
    end

    test "sends an error when it receives not pong" do
      %{pong: pong_pid} = PingPong.pingpong()
      send(pong_pid, {self(), "ping"})
      assert_receive {:error, :not_pong_error}
    end
  end
end
