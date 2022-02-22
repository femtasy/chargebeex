defmodule Chargebeex do
  @moduledoc """
  Chargebeex is a library that provides access interfaces for the
  [Chargebee
  API](https://apidocs.chargebee.com/docs/api?prod_cat_ver=1&lang=curl)
  of the **version 1 of the product catalog**.

  ## Testing

  This library provides a behaviour for each one of the modules of the
  supported resources to implement your own [behaviour
  mocks](https://github.com/dashbitco/mox).
  """

  @doc """
  Returns the `base_url` to be used on Chargebee API calls.
  """
  @spec base_url :: String.t()
  def base_url do
    Application.get_env(:chargebeex, :base_url)
  end

  @doc """
  Returns the Chargebee API key.
  """
  @spec api_key :: String.t()
  def api_key do
    Application.get_env(:chargebeex, :api_key)
  end
end
