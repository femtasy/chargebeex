defmodule Chargebeex.Invoices.FindPendingByCustomerIdTest do
  use ExUnit.Case, async: true

  import Mox

  alias Chargebeex.Invoices.FindPendingByCustomerId

  setup [:verify_on_exit!]

  describe "find_all_pending/2" do
    test "returns a response struct with the invoices" do
      customer_id = "117995"

      response_body = %{
        "list" => [%{"invoice" => %{"id" => "12123"}}]
      }

      Mox.expect(Tesla.MockAdapter, :call, fn %Tesla.Env{
                                                url: "/invoices/",
                                                query: [
                                                  "customer_id[is]": ^customer_id,
                                                  "status[is]": "payment_due"
                                                ]
                                              },
                                              _opts ->
        {:ok, %Tesla.Env{status: 200, body: response_body}}
      end)

      assert {:ok, ^response_body} = FindPendingByCustomerId.find_all_pending(customer_id)
    end
  end
end
