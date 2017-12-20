defmodule Vipex do
  @moduledoc """
  Documentation for Vipex.
  """

  alias Vipex.Transformer

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
    |> Enum.each(fn {key, _val} = key_tuple ->
      :ok = application
            |> config_from_env(key_tuple)
            |> (&Application.put_env(application, key, &1, opts)).()
    end)
    :ok
  end

  @spec config_from_env(:atom, {term, Keyword.t | any}) :: list({atom, term}) | {term, any}
  defp config_from_env(application, {key, [{_keyword, _val} | _tail] = keyword_list}) do
    Enum.map(keyword_list, fn {keyword, val} ->
      application
      |> Transformer.env_string(key, keyword)
      |> System.get_env
      |> (&({keyword, Transformer.parse_env_var(val, &1)})).()
    end)
  end

  defp config_from_env(application, {key, val}) do
    application
    |> Transformer.env_string(key)
    |> System.get_env
    |> (&Transformer.parse_env_var(val, &1)).()
  end

end
