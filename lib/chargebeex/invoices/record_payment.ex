defmodule Chargebeex.Invoices.RecordPayment do
  @moduledoc """
  This module allows to record a full payyment for a pending invoice
  """

  alias Chargebeex.Client

  @doc """
  Records an offline payment for the full amount of the given invoice.

  This function expects an external reference from the gateway and a
  transaction date.

  ### Options

  * `comment`: The comment to attach to the payment. Defaults to an empty string.
  * `payment_method`: Payment method used in the transaction. Defaults
  to `"other"` [See Chargebee
  docs](https://www.chargebee.com/docs/1.0/payment-method-overview.html)
  for more info.
  """
  @spec record_payment(invoice_id :: String.t(), id_at_gateway :: String.t(), date :: integer()) ::
          {:ok, map} | {:error, term}
  def record_payment(
        invoice_id,
        id_at_gateway,
        transaction_date,
        opts \\ []
      )
      when is_binary(invoice_id) do
    comment = Keyword.get(opts, :comment, "")
    payment_method = Keyword.get(opts, :payment_method, "other")

    Client.new()
    |> Tesla.post(
      "/invoices/#{invoice_id}/record_payment",
      %{
        "comment" => comment,
        "transaction[payment_method]": payment_method,
        "transaction[id_at_gateway]": id_at_gateway,
        "transaction[date]": transaction_date
      }
    )
    |> Client.handle_response()
  end
end
