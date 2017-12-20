defmodule VipexTest do
  use ExUnit.Case
  doctest Vipex

  setup do
    Application.put_env(:vipex, Vipex, nil)
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
end
