defmodule Chargebeex.Invoices.RecordPaymentTest do
  use ExUnit.Case, async: true

  alias Chargebeex.Invoices.RecordPayment

  describe "record_payment/2" do
    test "returns a response struct with the updated invoice and the created transaction" do
      transaction_id = "GATEWAY-TRANSACTION-ID"
      transaction_date = DateTime.to_unix(DateTime.utc_now())
      invoice_id = "invoice_id_2342"
      invoice = %{"invoice" => %{"id" => invoice_id, "status" => "payment_due"}}

      response_body = %{
        "invoice" => %{"id" => invoice_id},
        "transaction" => %{"id" => "transaction_id_2342"}
      }

      url = "/invoices/#{invoice_id}/record_payment"

      Mox.expect(Tesla.MockAdapter, :call, fn %Tesla.Env{
                                                url: ^url,
                                                method: :post,
                                                body: body
                                              },
                                              _opts ->
        assert %{
                 "comment" => "An invoice comment",
                 "transaction" => %{
                   "payment_method" => "a payment method",
                   "id_at_gateway" => ^transaction_id,
                   "date" => _transaction_date
                 }
               } = Plug.Conn.Query.decode(body)

        {:ok, %Tesla.Env{status: 200, body: response_body}}
      end)

      assert {:ok, ^response_body} =
               RecordPayment.record_payment(invoice, transaction_id, transaction_date,
                 comment: "An invoice comment",
                 payment_method: "a payment method"
               )
    end
  end
end
