# Pingpong

Exercise for Chapter 3 of The Little Elixir & OTP Guidebook.

Spawns two processes, one of which responds to "ping" with "pong", and the other
which responds to "pong" with "ping".

Spawn the processes using:
`%{ping: ping_pid, pong: pong_pid} = PingPong.pingpong()`

You can then send these messages using `send/2`. For example:
`send(ping_pid, {self(), "ping"})`

They will respond to the sending process (in this case `self()`) with a tuple
indicating whether they received the correct message. For example:

```
iex> send(ping_pid, {self(), "ping"})
{#PID<0.106.0>, "ping"}
iex> flush()
{:ok, "pong"}
:ok

iex> send(ping_pid, {self(), "pong"})
{#PID<0.106.0>, "pong"}
iex> flush()
{:error, :not_ping_error}
:ok
```
