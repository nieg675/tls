defmodule Listener do

  def start_listener(opts) do
    versions = Keyword.get(opts, :versions)
    verify_fun = Keyword.get(opts, :verify_fun)
    {crt, key} = generate_cert()

    socket_opts =
      [
        key:                  {:RSAPrivateKey, key},
        cert:                 crt,
        versions:             versions,
        verify:               :verify_peer,
        fail_if_no_peer_cert: true,
        verify_fun:           {verify_fun, []},
        port:                 49665,
        ciphers: :ssl.cipher_suites(:all,:'tlsv1.2') ++ :ssl.cipher_suites(:all,:'tlsv1.3')
      ]

    opts = %{
      connection_type:      :supervisor,
      socket_opts:          socket_opts,
    }

    {:ok, _} = :ranch.start_listener(:Tls, :ranch_ssl, opts, Prot, cert_verification: true)
  end

  def connect(tls_versions) do
    {client_cert, client_key} = generate_cert()

    :ssl.connect(
      {127, 0, 0, 1},
      49_665,
      [
        versions: tls_versions,
        ciphers: :ssl.cipher_suites(:all,:'tlsv1.2') ++ :ssl.cipher_suites(:all,:'tlsv1.3'),
        key: {:RSAPrivateKey, client_key},
        cert: client_cert,
      ]
    )
  end

  defp generate_cert() do
    private_key = X509.PrivateKey.new_rsa(2048)

    cert =
      X509.Certificate.self_signed(private_key, "/C=AU/ST=ST/O=O/CN=CN/OU=OU")
      |> X509.Certificate.to_der()

    key  = X509.PrivateKey.to_der(private_key)
    {cert, key}
  end

end
