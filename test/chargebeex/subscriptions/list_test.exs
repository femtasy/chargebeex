defmodule Chargebeex.Subscriptions.ListTest do
  use ExUnit.Case, async: true

  import Mox

  alias Chargebeex.Subscriptions.List

  setup [:verify_on_exit!]

  describe "list/2" do
    test "returns a response struct with the subscription and customer information" do
      response_body = %{"list" => [%{"card" => %{}, "customer" => %{}, "subscription" => %{}}]}

      Mox.expect(Tesla.MockAdapter, :call, fn %Tesla.Env{query: query, method: :get}, _opts ->
        assert query == ["customer_id[is]": "117995"]

        {:ok,
         %Tesla.Env{
           __client__: %Tesla.Client{},
           __module__: Tesla,
           body: response_body,
           method: :get,
           status: 200,
           url: "/hosted_pages/checkout_new"
         }}
      end)

      assert {:ok, ^response_body} = List.list(query: ["customer_id[is]": "117995"])
    end
  end
end
