# Vipex

Intended to replicate go's viper solution for combining configuration with environment overrides.

The following hierarchy is used for precedence
- explicit call to Application.put_env
- flag (not implemented)
- env
- config
- key/value store (not implemented)
- default

## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed
by adding `vipex` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:vipex, "~> 0.1.0"}
  ]
end
```

Documentation can be generated with [ExDoc](https://github.com/elixir-lang/ex_doc)
and published on [HexDocs](https://hexdocs.pm). Once published, the docs can
be found at [https://hexdocs.pm/vipex](https://hexdocs.pm/vipex).

