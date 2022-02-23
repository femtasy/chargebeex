defmodule Chargebeex.Subscriptions.UpdateTest do
  use ExUnit.Case, async: true

  import ExUnit.CaptureLog
  import Mox

  alias Chargebeex.Subscriptions.Update

  setup [:verify_on_exit!]

  describe "cancel_subscription/3" do
    @tag capture_log: true
    test "returns a response struct with the subscription and customer information" do
      response_body = %{"subscription" => %{}, "customer" => %{}}

      Mox.expect(Tesla.MockAdapter, :call, fn %Tesla.Env{
                                                url: "/subscriptions/SUBSCRIPTION_ID",
                                                method: :post
                                              },
                                              _opts ->
        {:ok, %Tesla.Env{status: 200, body: response_body}}
      end)

      assert {:ok, ^response_body} =
               Update.update_subscription(
                 "SUBSCRIPTION_ID",
                 %{"key" => "something to update"}
               )
    end

    test "logs a message when a subscription is cancelled" do
      Mox.expect(Tesla.MockAdapter, :call, fn %Tesla.Env{
                                                url: "/subscriptions/SUBSCRIPTION_ID",
                                                method: :post
                                              },
                                              _opts ->
        {:ok, %Tesla.Env{status: 200, body: %{}}}
      end)

      captured_log =
        capture_log(fn ->
          Update.update_subscription(
            "SUBSCRIPTION_ID",
            %{"key" => "something to update"}
          )
        end)

      assert captured_log =~
               "Updated subscription on Chargebee with %{\"key\" => \"something to update\"}"
    end
  end

  test "logs an error when the subscription cannot be updated" do
    Mox.expect(Tesla.MockAdapter, :call, fn %Tesla.Env{
                                              url: "/subscriptions/SUBSCRIPTION_ID",
                                              method: :post
                                            },
                                            _opts ->
      {:ok,
       %Tesla.Env{
         status: 409,
         body: %{
           "error_msg" => "Cannot update subscription"
         }
       }}
    end)

    captured_log =
      capture_log(fn ->
        assert {:error,
                %Tesla.Env{status: 409, body: %{"error_msg" => "Cannot update subscription"}}} ==
                 Update.update_subscription(
                   "SUBSCRIPTION_ID",
                   %{"key" => "something to update"}
                 )
      end)

    assert captured_log =~ "Subscription cannot be updated:"
  end
end
