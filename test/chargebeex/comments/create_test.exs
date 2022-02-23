defmodule Chargebeex.CommentsTest do
  use ExUnit.Case, async: true

  import ExUnit.CaptureLog

  alias Chargebeex.Comments.Create

  describe "create_comment/4" do
    test "returns a response struct with the subscription and customer information" do
      response_body = %{
        "comment" => %{
          "entity_id" => "subscription_id",
          "entity_type" => "subscription",
          "id" => "cmt___test__KyVnHhSBWm69N2s4",
          "notes" => "the comment"
        }
      }

      Mox.expect(Tesla.MockAdapter, :call, fn %Tesla.Env{url: "/comments", method: :post},
                                              _opts ->
        {:ok, %Tesla.Env{status: 200, body: response_body}}
      end)

      assert {:ok, ^response_body} =
               Create.create_comment("subscription", "subscription_id", "the comment")
    end

    test "logs a message when the request fails" do
      Mox.expect(Tesla.MockAdapter, :call, fn %Tesla.Env{url: "/comments", method: :post},
                                              _opts ->
        {:ok,
         %Tesla.Env{status: 400, body: %{"error_code" => "failed", "error_msg" => "the reason"}}}
      end)

      assert capture_log(fn ->
               Create.create_comment("subscription", "subscription_id", "the comment")
             end) =~ "Error failed creating comment: the reason"
    end
  end
end
