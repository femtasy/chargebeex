defmodule Chargebeex.PaymentSources.ListTest do
  use ExUnit.Case, async: true

  alias Chargebeex.PaymentSources.List

  describe "list/2" do
    test "returns a response struct with the payment sources" do
      response_body = %{
        "list" => [%{"payment_source" => %{}}]
      }

      Mox.expect(Tesla.MockAdapter, :call, fn %Tesla.Env{url: "/payment_sources/"}, _opts ->
        {:ok, %Tesla.Env{status: 200, body: response_body}}
      end)

      assert {:ok, ^response_body} = List.by_customer_id("117995")
    end
  end

  describe "filter_valid_payment_sources/1" do
    test "returns an empty list if there are not valid payment sources" do
      payment_sources = [
        %{
          "payment_source" => %{
            "customer_id" => "74797",
            "status" => "invalid",
            "issuing_country" => "AT",
            "type" => "paypal_express_checkout"
          }
        },
        %{
          "payment_source" => %{
            "customer_id" => "74797",
            "status" => "invalid",
            "issuing_country" => "US",
            "type" => "card"
          }
        }
      ]

      assert [] == List.filter_valid_payment_sources(payment_sources)
    end

    test "returns a list with payment sources if there are valida payment sources" do
      valid_payment_source = %{
        "payment_source" => %{
          "customer_id" => "74797",
          "status" => "valid",
          "issuing_country" => "US",
          "type" => "card"
        }
      }

      payment_sources = [
        %{
          "payment_source" => %{
            "customer_id" => "74797",
            "status" => "invalid",
            "issuing_country" => "AT",
            "type" => "paypal_express_checkout"
          }
        },
        valid_payment_source
      ]

      assert [^valid_payment_source] = List.filter_valid_payment_sources(payment_sources)
    end
  end
end
