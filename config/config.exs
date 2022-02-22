import Config

config :chargebeex,
  base_url: "",
  api_key: "an api key",
  max_request_retries: 0

config :tesla, adapter: Tesla.MockAdapter
