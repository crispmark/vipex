defmodule Vipex.Transformer do
  @moduledoc false

  @spec env_string(atom, term, atom) :: String.t
  def env_string(application, key, keyword \\ nil) do
    module = module_to_string(key)
    case keyword do
      nil -> "#{application}_#{module}" |> format_string
      keyword -> "#{application}_#{module}_#{keyword}" |> format_string
    end
  end

  @spec format_string(String.t) :: String.t
  defp format_string(str), do: str |> String.upcase |> String.replace(".", "_")

  @spec module_to_string(module) :: String.t
  defp module_to_string(module) do
    case to_string(module) do
      "Elixir." <> module_name -> module_name
      module_name -> module_name
    end
  end

  @spec parse_env_var(any, String.t | nil) :: any
  def parse_env_var(config_var, nil), do: config_var
  def parse_env_var(_config_var, ":" <> env_var), do: String.to_atom(env_var)
  def parse_env_var(_config_var, env_var) do
    case Poison.decode(env_var, keys: :atoms) do
      {:ok, decoded_var} -> decoded_var
      {:error, _} -> env_var
    end
  end
end
