defmodule Chargebeex.Plans.Retrieve do
  @moduledoc """
  Retrieves a plan from Chargebee.
  """

  alias Chargebeex.Client

  @doc """
  Retrieves a specific plan using the plan id.

  ## Examples

      iex> retrieve("sub_free")
      {:ok, %{"plan" =>
        %{
          "addon_applicability": "all",
          "charge_model": "per_unit",
          "currency_code": "USD",
          "enabled_in_hosted_pages": true,
          "enabled_in_portal": true,
          "free_quantity": 0,
          "giftable": false,
          "id": "sub_free",
          "is_shippable": false,
          "name": "sub_Free",
          "object": "plan",
          "period": 1,
          "period_unit": "month",
          "price": 0,
          "pricing_model": "per_unit",
          "show_description_in_invoices": false,
          "show_description_in_quotes": false,
          "status": "active",
          "taxable": true
          }
        }
      }
  """
  @spec retrieve(plan_id :: String.t()) :: {:ok, plan :: map()} | {:error, term()}
  def retrieve(plan_id) when is_binary(plan_id) do
    Client.new()
    |> Tesla.get("/plans/#{plan_id}")
    |> Client.handle_response()
  end
end
