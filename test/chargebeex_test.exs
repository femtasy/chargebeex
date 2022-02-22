defmodule ChargebeexTest do
  use ExUnit.Case, async: true

  doctest Chargebeex

  alias Chargebeex

  describe "base_url/0" do
    test "returns the base_url configuration" do
      assert Chargebeex.base_url() == ""
    end
  end

  describe "api_key/0" do
    test "returns the api_key configuration" do
      assert Chargebeex.api_key() == "an api key"
    end
  end
end
