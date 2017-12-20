defmodule Vipex do
  @moduledoc """
  Documentation for Vipex.
  """

  @spec apply_all_env_config(Keyword.t) :: :ok
  def apply_all_env_config(opts \\ []) do
    Application.loaded_applications()
    |> Enum.each(fn {app, _description, _version} ->
      apply_env_config(app, opts)
    end)
    :ok
  end

  @spec apply_env_config(atom, Keyword.t) :: :ok
  def apply_env_config(application, opts \\ []) do
    application
    |> Application.get_all_env
    |> Enum.each(fn {key, val} = key_tuple ->
      :ok = case config_from_env(application, key_tuple) do
        ^val -> :ok
        new_val -> Application.put_env(application, key, new_val, opts)
      end
    end)
    :ok
  end

  @spec config_from_env(atom, {term, Keyword.t | any}) :: Keyword.t | any
  defp config_from_env(application, {key, [{_keyword, _val} | _tail] = keyword_list}) do
    Enum.map(keyword_list, fn {keyword, val} ->
      application
      |> env_string(key, keyword)
      |> System.get_env
      |> (&({keyword, parse_env_var(val, &1)})).()
    end)
  end

  defp config_from_env(application, {key, val}) do
    application
    |> env_string(key)
    |> System.get_env
    |> (&parse_env_var(val, &1)).()
  end

  @spec env_string(atom, term, atom) :: String.t
  defp env_string(application, key, keyword \\ nil) do
    func = Application.get_env(:vipex, Vipex.Transformer)[:env_string]
    func.(application, key, keyword)
  end

  @spec parse_env_var(any, String.t | nil) :: any
  defp parse_env_var(config_var, env_var) do
    func = Application.get_env(:vipex, Vipex.Transformer)[:parse_env_var]
    func.(config_var, env_var)
  end

end
