defmodule Chargebeex.PortalSessions.CreateTest do
  use ExUnit.Case, async: true

  import Mox

  alias Chargebeex.PortalSessions.Create

  setup [:verify_on_exit!]

  describe "create/1" do
    test "returns a map with the response" do
      response_body = %{
        "portal_session" => %{
          "access_url" => "/portal/v2/authenticate?token=",
          "created_at" => 1_648_113_049,
          "customer_id" => "134194",
          "expires_at" => 1_648_116_649,
          "id" => "portal_asdf",
          "linked_customers" => [
            %{
              "customer_id" => "134194",
              "email" => "",
              "has_active_subscription" => true,
              "has_billing_address" => true,
              "has_payment_method" => true,
              "object" => "linked_customer"
            }
          ],
          "object" => "portal_session",
          "status" => "created",
          "token" => ""
        }
      }

      Mox.expect(Tesla.MockAdapter, :call, fn %Tesla.Env{url: url, method: method, body: body},
                                              _opts ->
        assert method == :post

        decoded_body = URI.decode_www_form(body)
        assert decoded_body == "customer[id]=134194"
        assert url == "portal_sessions"

        {:ok,
         %Tesla.Env{
           __client__: %Tesla.Client{},
           __module__: Tesla,
           body: response_body,
           method: :post,
           status: 200,
           url: "/portal_session"
         }}
      end)

      assert {:ok, ^response_body} = Create.create("134194")
    end
  end
end
