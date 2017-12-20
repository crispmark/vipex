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

```elixir
def deps do
  [
    {:vipex, "~> 0.1.0"}
  ]
end
```

