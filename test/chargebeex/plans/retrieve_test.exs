defmodule Chargebeex.Plans.RetrieveTest do
  use ExUnit.Case, async: true

  alias Chargebeex.Plans.Retrieve

  describe "retrieve/1" do
    test "returns a map with the plan information" do
      plan_id = "sub_free"

      response_body = %{
        "plan" => %{
          addon_applicability: "all",
          charge_model: "per_unit",
          currency_code: "USD",
          enabled_in_hosted_pages: true,
          enabled_in_portal: true,
          free_quantity: 0,
          giftable: false,
          id: "sub_free",
          is_shippable: false,
          name: "sub_Free",
          object: "plan",
          period: 1,
          period_unit: "month",
          price: 0,
          pricing_model: "per_unit",
          show_description_in_invoices: false,
          show_description_in_quotes: false,
          status: "active",
          taxable: true
        }
      }

      Mox.expect(Tesla.MockAdapter, :call, fn %Tesla.Env{url: url, method: method}, _opts ->
        assert method == :get

        assert url == "/plans/#{plan_id}"

        {:ok,
         %Tesla.Env{
           __client__: %Tesla.Client{},
           __module__: Tesla,
           body: response_body,
           method: :get,
           status: 200,
           url: "/plans/#{plan_id}"
         }}
      end)

      assert {:ok, ^response_body} = Retrieve.retrieve(plan_id)
    end
  end
end
