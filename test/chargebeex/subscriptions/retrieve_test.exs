defmodule Chargebeex.Subscriptions.RetrieveTest do
  use ExUnit.Case, async: true

  import Mox

  alias Chargebeex.Subscriptions.Retrieve

  setup [:verify_on_exit!]

  describe "retrieve_subscription/1" do
    test "returns a response struct with the subscription and customer information" do
      Mox.expect(Tesla.MockAdapter, :call, fn %Tesla.Env{
                                                url: "/subscriptions/SUBSCRIPTION_ID",
                                                method: :get
                                              },
                                              _opts ->
        {:ok, %Tesla.Env{status: 200, body: "a subscription"}}
      end)

      assert {:ok, "a subscription"} = Retrieve.retrieve_subscription("SUBSCRIPTION_ID")
    end
  end
end
