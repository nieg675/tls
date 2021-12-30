defmodule TlsTest do
  use ExUnit.Case

  test "TLS 1.2 with failing handshake" do
    Application.ensure_started(:ranch)

    Listener.start_listener([versions: [:"tlsv1.2"], verify_fun: fn(_c, _r, _s) -> {:fail, :internal_error} end])

    #returns an error as expected
    assert {:error, _} = Listener.connect([:"tlsv1.2"])

    Application.stop(:ranch)
  end

  test "TLS 1.3 with failing handshake" do
    Application.ensure_started(:ranch)

    Listener.start_listener([versions: [:"tlsv1.3"], verify_fun: fn(_c, _r, _s) -> {:fail, :internal_error} end])

    #returns ok instead of an error
    assert {:ok, socket} = Listener.connect([:"tlsv1.3"])

    Application.stop(:ranch)
  end

end
