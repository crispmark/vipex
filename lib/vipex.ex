defmodule Vipex do
  @moduledoc """
  Documentation for Vipex.
  """

  alias Vipex.Transformer

  @spec apply_all_env_config(Keyword.t) :: :ok
  def apply_all_env_config(opts \\ []) do
    Application.loaded_applications()
    |> Enum.map(fn {app, _description, _version} -> apply_env_config(app, opts) end)
    :ok
  end

  @spec apply_env_config(atom, Keyword.t) :: :ok
  def apply_env_config(application, opts \\ []) do
    Application.get_all_env(application)
    |> Enum.map(fn {key, _val} = key_tuple ->
      :ok = application
      |> config_from_env(key_tuple)
      |> (&Application.put_env(application, key, &1, opts)).()
    end)
    :ok
  end

  @spec config_from_env(:atom, {term, Keyword.t}) :: list({atom, term})
  defp config_from_env(application, {key, [{_keyword, _val} | _tail] = keyword_list}) do
    keyword_list
    |> Enum.map(fn {keyword, val} ->
      env_val = Transformer.env_string(application, key, keyword)
                |> System.get_env
      {keyword, Transformer.parse_env_var(val, env_val)}
    end)
  end

  @spec config_from_env(:atom, {term, any}) :: {term, any}
  defp config_from_env(application, {key, val}) do
    env_val = Transformer.env_string(application, key)
              |> System.get_env
    Transformer.parse_env_var(val, env_val)
  end


end