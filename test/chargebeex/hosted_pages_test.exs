defmodule Chargebeex.HostedPageCheckoutTest do
  use ExUnit.Case, async: true

  import ExUnit.CaptureLog
  import Mox

  alias Chargebeex.HostedPages

  setup [:verify_on_exit!]

  describe "create_checkout/2" do
    setup [:customer]

    test "sends optional params to Chargebee", %{
      customer: %{id: id, email: email, locale: locale},
      plan_id: plan_id
    } do
      chargebee_checkout_response = %{
        "hosted_page" => %{
          "created_at" => 1_644_940_689,
          "embed" => false,
          "expires_at" => 1_644_951_489,
          "id" => "xTDWYMWSePGDjypcdagkkdgQdIkac3DTk",
          "object" => "hosted_page",
          "resource_version" => 1_644_940_689_904,
          "state" => "created",
          "type" => "checkout_new",
          "updated_at" => 1_644_940_689,
          "url" => "/pages/v3/xTDWYMWSePGDjypcdagkkdgQdIkac3DTk/"
        }
      }

      Mox.expect(Tesla.MockAdapter, :call, fn %Tesla.Env{body: body, method: method}, _opts ->
        assert method == :post

        decoded_body = URI.decode_www_form(body)

        assert decoded_body ==
                 "customer[email]=fake_email&customer[id]=23&customer[locale]=cat&subscription[plan_id]=my-plan&coupon_ids[0]=23&coupon_ids[1]=5"

        {:ok,
         %Tesla.Env{
           body: chargebee_checkout_response,
           method: :post,
           status: 200,
           url: "/hosted_pages/checkout_new"
         }}
      end)

      assert {:ok, ^chargebee_checkout_response} =
               HostedPages.create_checkout(plan_id, id, email, locale, coupon_ids: ["23", "5"])
    end

    test "sends correct params to Chargebee", %{
      customer: %{id: id, email: email, locale: locale},
      plan_id: plan_id
    } do
      chargebee_checkout_response = %{
        "hosted_page" => %{
          "created_at" => 1_644_940_689,
          "embed" => false,
          "expires_at" => 1_644_951_489,
          "id" => "xTDWYMWSePGDjypcdagkkdgQdIkac3DTk",
          "object" => "hosted_page",
          "resource_version" => 1_644_940_689_904,
          "state" => "created",
          "type" => "checkout_new",
          "updated_at" => 1_644_940_689,
          "url" => "/pages/v3/xTDWYMWSePGDjypcdagkkdgQdIkac3DTk/"
        }
      }

      Mox.expect(Tesla.MockAdapter, :call, fn %Tesla.Env{body: body, method: method}, _opts ->
        assert method == :post

        decoded_body = URI.decode_www_form(body)

        assert decoded_body ==
                 "customer[email]=fake_email&customer[id]=23&customer[locale]=cat&subscription[plan_id]=my-plan"

        {:ok,
         %Tesla.Env{
           body: chargebee_checkout_response,
           method: :post,
           status: 200,
           url: "/hosted_pages/checkout_new"
         }}
      end)

      assert {:ok, ^chargebee_checkout_response} =
               HostedPages.create_checkout(plan_id, id, email, locale)
    end
  end

  describe "when Chargebee returns error" do
    setup [:customer]

    test "logs a message", %{customer: %{id: id, email: email, locale: locale}, plan_id: plan_id} do
      Mox.expect(Tesla.MockAdapter, :call, fn _, _opts ->
        {:ok,
         %Tesla.Env{
           body: %{
             "api_error_code" => "configuration_incompatible",
             "error_code" => "api_restricted",
             "error_msg" => "An extrange error impossible to understand",
             "http_status_code" => 400,
             "message" => "An extrange error imposible to understand"
           },
           method: :post,
           status: 400,
           url: "/hosted_pages/checkout_new"
         }}
      end)

      error =
        "Error api_restricted creating new checkout: An extrange error impossible to understand"

      assert capture_log(fn ->
               assert {:error, ^error} = HostedPages.create_checkout(plan_id, id, email, locale)
             end) =~
               error
    end
  end

  #
  # Private functions
  #

  defp customer(_context) do
    %{customer: %{id: "23", email: "fake_email", locale: "cat"}, plan_id: "my-plan"}
  end
end
