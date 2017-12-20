defmodule VipexTest do
  use ExUnit.Case
  doctest Vipex

  @default_transformer_config Application.get_env(:vipex, Vipex.Transformer)

  setup do
    Application.put_env(:vipex, Vipex, nil)
    Application.put_env(:vipex, Vipex.Transformer, @default_transformer_config)
  end

  describe "apply_env_config" do
    test "only replaces one keyword when multiple present" do
      Application.put_env(:vipex, Vipex, [{:first_test_var, "first_test"}, {:second_test_var, "second_test"}])
      assert [{:first_test_var, "first_test"}, {:second_test_var, "second_test"}] == Application.get_env(:vipex, Vipex)
      System.put_env("VIPEX_VIPEX_FIRST_TEST_VAR", "replacement_test")
      Vipex.apply_env_config(:vipex)
      assert [{:first_test_var, "replacement_test"}, {:second_test_var, "second_test"}] == Application.get_env(:vipex, Vipex)
    end

    test "fully replaces value when it is not a keyword list" do
      Application.put_env(:vipex, Vipex, [:only_test_var])
      assert [:only_test_var] == Application.get_env(:vipex, Vipex)
      System.put_env("VIPEX_VIPEX", "only_replacement")
      Vipex.apply_env_config(:vipex)
      assert "only_replacement" == Application.get_env(:vipex, Vipex)
    end
  end

  describe "transforms with config functions" do
    test "can replace env_string/3" do
      Application.put_env(:vipex, Vipex, [:only_test_var])
      config = Keyword.put(@default_transformer_config, :env_string, fn _, module, _ ->
        case module do
          Vipex -> "MAPS_TO_VIPEX"
          _ -> "MAPS_TO_REST"
        end
      end)
      Application.put_env(:vipex, Vipex.Transformer, config)
      assert [:only_test_var] == Application.get_env(:vipex, Vipex)
      System.put_env("MAPS_TO_VIPEX", "only_replacement")
      Vipex.apply_env_config(:vipex)
      assert "only_replacement" == Application.get_env(:vipex, Vipex)
    end

    test "can replace parse_env_var/2" do
      Application.put_env(:vipex, Vipex, [:only_test_var])
      config = Keyword.put(@default_transformer_config, :parse_env_var, fn config_var, env_var ->
        case env_var do
          nil -> config_var
          _ -> "default"
        end
      end)
      Application.put_env(:vipex, Vipex.Transformer, config)
      assert [:only_test_var] == Application.get_env(:vipex, Vipex)
      System.put_env("VIPEX_VIPEX", "only_replacement")
      Vipex.apply_env_config(:vipex)
      assert "default" == Application.get_env(:vipex, Vipex)
    end
  end
end
