defmodule Chargebeex.Invoices.FindPendingByCustomerId do
  @moduledoc """
  This module is used to find pending invoices by customer id using
  [Chargebee](https://apidocs.chargebee.com/docs/api/invoices?prod_cat_ver=1#list_invoices).
  """

  alias Chargebeex.Client

  @doc """
  Retrieves all the pending invoices for the given customer id.
  """
  @spec find_all_pending(String.t()) ::
          {:ok, map} | {:error, term}
  def find_all_pending(customer_id) do
    Client.new()
    |> Tesla.get("/invoices/",
      query: ["customer_id[is]": "#{customer_id}", "status[is]": "payment_due"]
    )
    |> Client.handle_response()
  end
end
