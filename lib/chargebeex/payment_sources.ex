defmodule Chargebeex.PaymentSources do
  @moduledoc """
  Module that provides functions for [Payment
  Sources](https://apidocs.chargebee.com/docs/api/payment_sources#list_payment_sources).
  """

  alias Chargebeex.PaymentSources.List

  defmodule Behaviour do
    @moduledoc false

    @callback by_customer_id(customer_id :: String.t()) :: {:ok, map} | {:error, term}

    @callback filter_valid_payment_sources(list(map())) :: list(map())
  end

  @behaviour __MODULE__.Behaviour

  @impl __MODULE__.Behaviour
  defdelegate by_customer_id(customer_id), to: List

  @impl __MODULE__.Behaviour
  defdelegate filter_valid_payment_sources(payment_sources), to: List
end
