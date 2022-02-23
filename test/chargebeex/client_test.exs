defmodule Chargebeex.ClientTest do
  use ExUnit.Case, async: true

  alias Chargebeex.Client

  describe "new/1" do
    test "returns a new Tesla client" do
      assert %Tesla.Client{
               pre: [
                 {Tesla.Middleware.BaseUrl, _, _},
                 {Tesla.Middleware.BasicAuth, _, [[username: _]]},
                 {Tesla.Middleware.Retry, _, [[max_retries: 0, should_retry: _]]},
                 {Tesla.Middleware.FormUrlencoded, _, _},
                 {Tesla.Middleware.JSON, _, _}
               ]
             } = Client.new()
    end
  end

  describe "handle_response/1" do
    test "when the response is ok and the HTTP status is 200 then a tuple with ok and the body is returned" do
      assert {:ok, "body"} = Client.handle_response({:ok, %Tesla.Env{status: 200, body: "body"}})
    end

    test "when the response is ok and the HTTP status is not between 200 and 299 then an error tuple is returned" do
      assert {:error, %Tesla.Env{}} =
               Client.handle_response({:ok, %Tesla.Env{status: 400, body: "Random error folk."}})
    end

    test "when the response is error then an error tuple is returned" do
      assert {:error, _} = Client.handle_response({:error, "something"})
    end
  end
end
