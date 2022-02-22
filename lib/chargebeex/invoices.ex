defmodule Chargebeex.Invoices do
  @moduledoc """
  Module that provides functions for [Chargebee
  invoices](https://apidocs.chargebee.com/docs/api/invoices?prod_cat_ver=1).
  """

  alias Chargebeex.Invoices.{FindPendingByCustomerId, RecordPayment}

  defmodule Behaviour do
    @moduledoc false

    @callback find_all_pending(String.t()) :: {:ok, map} | {:error, term}

    @callback record_payment(map(), String.t(), integer()) :: {:ok, map} | {:error, term}

    @callback record_payment(map(), String.t(), integer(), keyword()) ::
                {:ok, map} | {:error, term}
  end

  @behaviour __MODULE__.Behaviour

  @impl __MODULE__.Behaviour
  defdelegate find_all_pending(customer_id), to: FindPendingByCustomerId

  @impl __MODULE__.Behaviour
  defdelegate record_payment(invoice, id_at_gateway, transaction_date, opts \\ []),
    to: RecordPayment
end
