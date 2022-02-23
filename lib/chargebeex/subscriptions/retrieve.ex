defmodule Chargebeex.Subscriptions.Retrieve do
  @moduledoc """
  Module that provides functions to interact with
  [subscriptions](https://apidocs.chargebee.com/docs/api/subscriptions).
  """

  alias Chargebeex.Client

  @doc """
  Retrieves the subscription identified by the given 'subscription_id'.

  See: https://apidocs.chargebee.com/docs/api/subscriptions#retrieve_a_subscription
  """
  @spec retrieve_subscription(subscription_id :: String.t()) ::
          {:ok, map} | {:error, term}
  def retrieve_subscription(subscription_id) when is_binary(subscription_id) do
    Client.new()
    |> Tesla.get("/subscriptions/#{subscription_id}")
    |> Client.handle_response()
  end
end
