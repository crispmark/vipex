# Vipex
[![CircleCI](https://circleci.com/gh/crispmark/vipex.svg?style=svg&circle-token=5471592aa87d6dc0d8cc34a650b1021a7c626328)](https://circleci.com/gh/crispmark/vipex)

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

