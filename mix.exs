defmodule TlsTest.MixProject do
  use Mix.Project

  def project do
    [
      app: :tls_test,
      version: "0.1.0",
      elixir: "~> 1.11",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  def application do
    [
      extra_applications: [:logger, :ssl]
    ]
  end

  defp deps do
    [
      {:ranch, "~> 1.7"},
      {:x509, "~> 0.8"}
    ]
  end
end
