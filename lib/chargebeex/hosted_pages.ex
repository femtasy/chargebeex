defmodule Chargebeex.HostedPages do
  @moduledoc """
  This module provides the functions [Chargebee hosted
  pages](https://apidocs.chargebee.com/docs/api/hosted_pages?prod_cat_ver=1&lang=curl).
  """
  require Logger

  alias Chargebeex.HostedPages.Checkout

  defmodule Behaviour do
    @moduledoc false

    @callback create_checkout(
                plan_id :: String.t(),
                customer_id :: String.t(),
                email :: String.t(),
                locale :: String.t(),
                opts :: Checkout.optional_fields()
              ) ::
                {:error, any} | {:ok, map()}

    @callback create_checkout(
                plan_id :: String.t(),
                customer_id :: String.t(),
                email :: String.t(),
                locale :: String.t()
              ) ::
                {:error, any} | {:ok, map()}
  end

  @behaviour __MODULE__.Behaviour

  @impl __MODULE__.Behaviour
  defdelegate create_checkout(plan_id, customer_id, email, locale, opts \\ []), to: Checkout
end
