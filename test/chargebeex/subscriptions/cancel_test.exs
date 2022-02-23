defmodule Chargebeex.Subscriptions.CancelTest do
  use ExUnit.Case, async: true

  import ExUnit.CaptureLog
  import Mox

  alias Chargebeex.Subscriptions.Cancel

  setup [:verify_on_exit!]

  describe "cancel_subscription/3" do
    test "returns a response struct with the subscription and customer information" do
      response_body = %{"subscription" => %{}, "customer" => %{}}

      Mox.expect(Tesla.MockAdapter, :call, fn %Tesla.Env{
                                                url: "/subscriptions/SUBSCRIPTION_ID/cancel"
                                              },
                                              _opts ->
        {:ok, %Tesla.Env{status: 200, body: response_body}}
      end)

      assert {:ok, ^response_body} =
               Cancel.cancel_subscription("SUBSCRIPTION_ID", end_of_term: false)
    end

    test "logs a message when a subscription is cancelled" do
      Mox.expect(Tesla.MockAdapter, :call, fn %Tesla.Env{
                                                url: "/subscriptions/SUBSCRIPTION_ID/cancel"
                                              },
                                              _opts ->
        {:ok, %Tesla.Env{status: 200, body: %{}}}
      end)

      assert capture_log(fn ->
               Cancel.cancel_subscription("SUBSCRIPTION_ID", end_of_term: false)
             end) =~ "Cancelled subscription on Chargebee"
    end
  end

  test "logs an error when the subscription is in an invalid state for cancel" do
    Mox.expect(Tesla.MockAdapter, :call, fn %Tesla.Env{
                                              url: "/subscriptions/SUBSCRIPTION_ID/cancel"
                                            },
                                            _opts ->
      {:ok,
       %Tesla.Env{
         status: 409,
         body: %{
           "api_error_code" => "invalid_state_for_request",
           "error_code" => "invalid_state_for_cancel",
           "error_msg" => "Cannot cancel a subscription that is Cancelled or Expired already",
           "http_status_code" => 409,
           "message" => "Cannot cancel a subscription that is Cancelled or Expired already",
           "type" => "invalid_request"
         }
       }}
    end)

    assert capture_log(fn ->
             assert {:ok, %{}} ==
                      Cancel.cancel_subscription("SUBSCRIPTION_ID", end_of_term: false)
           end) =~
             "Subscription in the wrong status for cancel: Cannot cancel a subscription that is Cancelled or Expired already"
  end
end
