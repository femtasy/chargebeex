defmodule Chargebeex.Subscriptions.Update do
  @moduledoc """
  Module that provides functions to [update Chargebee
  subscriptions](https://apidocs.chargebee.com/docs/api/subscriptions?prod_cat_ver=1&lang=curl#update_a_subscription).
  """

  require Logger

  alias Chargebeex.Client

  @doc """
  Updates the subscription with the provided fields.
  """
  @spec update_subscription(subscription_id :: String.t(), map()) ::
          {:ok, map} | {:error, term}
  def update_subscription(subscription_id, attrs) do
    Logger.metadata(subscription_id: subscription_id)

    Logger.info("Update subscription #{subscription_id} with #{inspect(attrs)}")

    Client.new()
    |> Tesla.post("/subscriptions/#{subscription_id}", attrs)
    |> Client.handle_response()
    |> maybe_log_message(attrs)
  end

  #
  # Private function
  #

  @spec maybe_log_message({:ok, map} | {:error, term}, map()) :: {:ok, map} | {:error, term}
  defp maybe_log_message({:ok, _response} = result, attrs) do
    Logger.info("Updated subscription on Chargebee with #{inspect(attrs)}")

    result
  end

  defp maybe_log_message(
         {:error,
          %Tesla.Env{
            body: error_response
          }} = result,
         _attrs
       ) do
    Logger.error("Subscription cannot be updated: #{inspect(error_response)}")

    result
  end

  defp maybe_log_message(result, _attrs), do: result
end
