defmodule Prot do

  def start_link(ref, socket, transport, opts) do
    pid = spawn_link(__MODULE__, :init, [ref, socket, transport, opts])
    {:ok, pid}
  end

  def init(ref, socket, transport, _opts) do
    {:ok, _socket} = :ranch.handshake(ref)
    loop(socket, transport)
  end

  def loop(socket, transport) do
    case :ssl.recv(socket, 0, 5000) do
      {:ok, data} ->
          IO.inspect(data)
          :ssl.send(socket, data)
          loop(socket, transport)
      _ ->
          loop(socket, transport)
    end
  end
end
