defmodule Vipex.Mixfile do
  use Mix.Project

  def project do
    [
      app: :vipex,
      version: "0.1.0",
      elixir: "~> 1.5",
      start_permanent: Mix.env == :prod,
      deps: deps(),
      description: description(),
      package: package(),
      name: "Vipex",
      source_url: "https://github.com/crispmark/vipex"
    ]
  end

  def application do
    []
  end

  defp deps do
    [
      {:poison, "~> 3.1"},
      {:credo, "~> 0.8", only: :test, runtime: false},
      {:dialyxir, "~> 0.5", only: :test, runtime: false},
      {:ex_doc, "~> 0.18", only: :dev, runtime: false},
    ]
  end

  defp description() do
    "Provides a mechanism for overriding configurations with environment variables."
  end

  defp package() do
    [
      name: "vipex",
      files: ["lib", "config", "mix.exs", "README*"],
      maintainers: ["Mark Crisp"],
      licenses: ["MIT"],
      links: %{"GitHub" => "https://github.com/crispmark/vipex"}
    ]
  end
end
