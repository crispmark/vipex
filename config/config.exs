use Mix.Config


config :vipex, Vipex.Transformer,
       parse_env_var: &Vipex.Transformer.parse_env_var/2,
       env_string: &Vipex.Transformer.env_string/3