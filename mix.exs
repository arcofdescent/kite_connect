defmodule KiteConnect.MixProject do
  use Mix.Project

  def project do
    [
      app: :kite_connect,
      version: "0.1.6",
      elixir: "~> 1.6",
      start_permanent: Mix.env() == :prod,
      description: "Elixir module for the Zerodha Kite Connect API",
      package: package(),
      deps: deps(),
    ]
  end

  defp package do
    [
      files: ["lib", "mix.exs", "README.md", "LICENSE", "CHANGELOG.md"],
      maintainers: ["Rohan Almeida"],
      licenses: ["Apache 2.0"],
      links: %{"GitHub" => "https://github.com/arcofdescent/kite_connect"}
    ]
  end
  
  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:httpoison, "~> 1.3"},
      {:poison, "~> 3.0"},
      {:ex_doc, "~> 0.19"},
    ]
  end
end
