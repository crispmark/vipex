defmodule Vipex do
  @moduledoc """
  Maps environment variables to configuration options
  """

  @doc"""
  Applies the environment variables to all loaded applications' configs
  """
  @spec apply_all_env_config(Keyword.t) :: :ok
  def apply_all_env_config(opts \\ []) do
    Application.loaded_applications()
    |> Enum.each(fn {app, _description, _version} ->
      :ok = apply_env_config(app, opts)
    end)
    :ok
  end


  @doc """
  Applies the environment variables to the provided application's config

  If using the default transformers and the following config

      config :guardian, Guardian,
        allowed_algos: ["HS256"],
        issuer: "issuer-dev.auth0.com",
        allowed_drift: 2000,
        verify_issuer: false

  Then if environment variables were set as follows

      System.put_env("GUARDIAN_GUARDIAN_ALLOWED_ALGOS", "[\\"RS256\\"]")
      System.put_env("GUARDIAN_GUARDIAN_ISSUER", "issuer-prod.auth0.com")
      System.put_env("GUARDIAN_GUARDIAN_ALLOWED_DRIFT", "1000")
      System.put_env("GUARDIAN_GUARDIAN_VERIFY_ISSUER", "true")

  The resulting updated config would be

      config :guardian, Guardian,
        allowed_algos: ["RS256"],
        issuer: "issuer-prod.auth0.com",
        allowed_drift: 1000,
        verify_issuer: true
  """
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

  @spec env_string(atom, term, atom | nil) :: String.t
  defp env_string(application, key, keyword \\ nil) do
    func = Application.get_env(:vipex, Vipex.Transformer)[:env_string]
    func.(application, key, keyword)
  end

  @spec parse_env_var(any, String.t | nil) :: any
  defp parse_env_var(config_var, nil), do: config_var
  defp parse_env_var(config_var, env_var) do
    func = Application.get_env(:vipex, Vipex.Transformer)[:parse_env_var]
    func.(config_var, env_var)
  end

end
