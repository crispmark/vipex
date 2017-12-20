defmodule Vipex.TransformerTest do
  use ExUnit.Case
  alias Vipex.Transformer

  doctest Transformer

  describe "env_string" do
    test "inserts underscores, and transforms to uppercase" do
      assert "VIPEX_VIPEX_KEY" == Transformer.env_string(:vipex, :vipex, :key)
    end

    test "removes Elixir. prefix from string" do
      assert "VIPEX_VIPEX_KEY" == Transformer.env_string(:vipex, Vipex, :key)
    end

    test "handles case when no key provided" do
      assert "VIPEX_VIPEX" == Transformer.env_string(:vipex, Vipex)
    end

    test "converts periods to underscores" do
      assert "VIPEX_VIPEX_TRANSFORMER" == Transformer.env_string(:vipex, Vipex.Transformer)
    end
  end

  describe "parse_env_var" do
    test "returns original config value when env var is nil" do
      assert "original" == Transformer.parse_env_var("original", nil)
    end

    test "parses atom" do
      assert :atom == Transformer.parse_env_var("original", ":atom")
    end

    test "parses value handled by poison" do
      assert 1 == Transformer.parse_env_var("original", "1")
    end

    test "values that cannot be parsed by poison are left raw" do
      assert "{:raw, \"value\"}" == Transformer.parse_env_var("original", "{:raw, \"value\"}")
    end
  end
end
