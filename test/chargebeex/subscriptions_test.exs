defmodule Chargebeex.SubscriptionsTest do
  use ExUnit.Case, async: true

  import Mox

  doctest Chargebeex.Subscriptions

  alias Chargebeex.Subscriptions

  setup [:verify_on_exit!]

  describe "has_an_active_subscription?/1" do
    test "returns true if the customer has one or more active subscriptions" do
      response_body = %{"list" => ["subscription_1", "subscription_2"]}

      Mox.expect(Tesla.MockAdapter, :call, fn %Tesla.Env{
                                                url: "/subscriptions/",
                                                method: :get
                                              },
                                              _opts ->
        {:ok,
         %Tesla.Env{
           body: response_body,
           status: 200
         }}
      end)

      assert Subscriptions.has_an_active_subscription?(1234)
    end

    test "returns false if the customer does not have active subscriptions" do
      response_body = %{"list" => []}

      Mox.expect(Tesla.MockAdapter, :call, fn %Tesla.Env{
                                                url: "/subscriptions/",
                                                method: :get
                                              },
                                              _opts ->
        {:ok,
         %Tesla.Env{
           body: response_body,
           status: 200
         }}
      end)

      refute Subscriptions.has_an_active_subscription?(1234)
    end

    test "returns false in any other case" do
      Mox.expect(Tesla.MockAdapter, :call, fn %Tesla.Env{
                                                url: "/subscriptions/",
                                                method: :get
                                              },
                                              _opts ->
        {:error, "connection refused"}
      end)

      refute Subscriptions.has_an_active_subscription?(1234)
    end
  end

  describe "has_an_in_trial_subscription?/1" do
    test "returns true if the customer has one or more in_trial subscriptions" do
      response_body = %{"list" => ["subscription_1", "subscription_2"]}

      Mox.expect(Tesla.MockAdapter, :call, fn %Tesla.Env{
                                                url: "/subscriptions/",
                                                method: :get
                                              },
                                              _opts ->
        {:ok, %Tesla.Env{status: 200, body: response_body}}
      end)

      assert Subscriptions.has_an_in_trial_subscription?(1234)
    end

    test "returns false if the customer does not have in_trial subscriptions" do
      response_body = %{"list" => []}

      Mox.expect(Tesla.MockAdapter, :call, fn %Tesla.Env{
                                                url: "/subscriptions/",
                                                method: :get
                                              },
                                              _opts ->
        {:ok, %Tesla.Env{status: 200, body: response_body}}
      end)

      refute Subscriptions.has_an_in_trial_subscription?(1234)
    end

    test "returns false in any other case" do
      Mox.expect(Tesla.MockAdapter, :call, fn %Tesla.Env{
                                                url: "/subscriptions/",
                                                method: :get
                                              },
                                              _opts ->
        {:error, "connection refused"}
      end)

      refute Subscriptions.has_an_in_trial_subscription?(1234)
    end
  end
end
