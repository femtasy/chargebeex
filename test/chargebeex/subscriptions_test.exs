defmodule Chargebeex.SubscriptionsTest do
  use ExUnit.Case, async: true

  import Mox

  doctest Chargebeex.Subscriptions

  alias Chargebeex.Subscriptions

  setup [:verify_on_exit!]

  describe "validate_subscriptions_response/1" do
    test "returns a tuple if the result has is error" do
      validated_subscriptions = Subscriptions.validate_subscriptions_response({:error, 1234})

      assert validated_subscriptions == {:error, "Error getting the subscriptions"}
    end

    test "returns the subscriptions is the result is success" do
      validated_subscriptions =
        Subscriptions.validate_subscriptions_response({:ok, %{"list" => ["a subscription"]}})

      assert validated_subscriptions == ["a subscription"]
    end
  end

  describe "unwrap_subscriptions_response/1" do
    test "returns a tuple if the result has is error" do
      validated_subscriptions = Subscriptions.unwrap_subscriptions_response({:error, 1234})

      assert validated_subscriptions == {:error, 1234}
    end

    test "returns the subscriptions is the result is success" do
      unwrapper_subscriptions =
        Subscriptions.unwrap_subscriptions_response([
          %{"subscription" => "subscription 1"},
          %{"subscription" => "subscription 2"}
        ])

      assert unwrapper_subscriptions == ["subscription 1", "subscription 2"]
    end
  end
end
