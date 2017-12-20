defmodule Vipex.Transformer do
  @moduledoc """
  A module for transforming configuration paths and environment variables

  Provides the default methods of transforming a configuration path to an environment variable, and automatically
  transforming string values obtained from environment variables to atoms, numbers, lists, maps. Users can specify
  their own transformers as follows.

  Define the new functions in a module

      defmodule MyTransformer do
        @spec my_env_parser(atom, term, atom | nil) :: String.t
        def my_env_parser(application, key, keyword) do
          "ENV_VAR"
        end

        @spec my_var_parser(any, String.t) :: any
        def my_env_parser(config_var, env_var) do
          env_var
        end
      end

  Override the old transfomers in the configuration

      config :vipex, Vipex.Transformer,
        env_string: &MyTransformer.my_env_parser/3,
        parse_env_var: &MyTransformer.my_var_parser/2
  """

  @doc """
  Maps a configuration variable to an environment variable

  For example, given the following config

      config :vipex, Vipex.Transformer,
        parse_env_var: &Vipex.Transformer.parse_env_var/2,
        env_string: &Vipex.Transformer.env_string/3

  The function will be called as follows

      iex> Vipex.Transformer.env_string(:vipex, Vipex.Transformer, :parse_env_var)
      "VIPEX_VIPEX_TRANSFORMER_PARSE_ENV_VAR"

      iex> Vipex.Transformer.env_string(:vipex, Vipex.Transformer, :env_string)
      "VIPEX_VIPEX_TRANSFORMER_ENV_STRING"

  Given a config with a single value or non-keyword list

      config :vipex, Vipex.Transformer,
        [:parse_env_var]

  The function will be called as follows

      iex> Vipex.Transformer.env_string(:vipex, Vipex.Transformer, nil)
      "VIPEX_VIPEX_TRANSFORMER"
  """
  @spec env_string(atom, term, atom | nil) :: String.t
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

  @doc """
  Parses a string obtained from an environment variable

  If the provided string begins with a `:`, it will be converted to an atom

      iex> Vipex.Transformer.parse_env_var(:old_var, ":new_var")
      :new_var

  If the provided string is a number, map or list and can be parsed by Poison, it will do so

      iex> Vipex.Transformer.parse_env_var(1, "2.3")
      2.3

      iex> Vipex.Transformer.parse_env_var([1, 2], [2, 3])
      [2, 3]

      iex> Vipex.Transformer.parse_env_var(%{map: false}, "{\\"map\\": true}")
      %{map: true}

  If the provided string is unparseable, it will remain a string

      iex> Vipex.Transformer.parse_env_var({:error, :tuple}, "{:ok, :tuple}")
      "{:ok, :tuple}"

  """
  @spec parse_env_var(any, String.t) :: any
  def parse_env_var(_config_var, ":" <> env_var), do: String.to_atom(env_var)
  def parse_env_var(_config_var, env_var) do
    case Poison.decode(env_var, keys: :atoms) do
      {:ok, decoded_var} -> decoded_var
      {:error, _} -> env_var
    end
  end
end
