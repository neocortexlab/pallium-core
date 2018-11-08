defmodule PalliumCore.MixProject do
  use Mix.Project

  def project do
    [
      app: :pallium_core,
      version: "0.2.0",
      elixir: "~> 1.7",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  def application do
    [
      # extra_applications: [:logger]
    ]
  end

  defp deps do
    [
      {:ed25519, "~> 1.3"},
      {:ex_rlp, "~> 0.3.0"},
    ]
  end
end
