defmodule Chargebeex.Subscriptions.Cancel do
  @moduledoc """
  Module that provides a function to cancel a Charbebee [subscription](https://apidocs.chargebee.com/docs/api/subscriptions?lang=curl#cancel_a_subscription).
  """

  require Logger

  alias Chargebeex.Client

  defmodule Behaviour do
    @moduledoc false

    @callback cancel_subscription(subscription_id :: String.t(), end_of_term: boolean()) ::
                {:ok, map} | {:error, term}
  end

  @behaviour __MODULE__.Behaviour

  @doc """
  Cancels a subscription by the given 'subscription_id'.

  If `end_of_term` is passed as true, the subscription will be scheduled
  for cancellation at the end of the current billing cycle, if not, it
  will be cancelled right away.
  """
  @impl __MODULE__.Behaviour
  def cancel_subscription(
        subscription_id,
        opts \\ []
      )
      when is_binary(subscription_id) do
    end_of_term = Keyword.get(opts, :end_of_term, false)

    Client.new()
    |> Tesla.post("/subscriptions/#{subscription_id}/cancel", %{"end_of_term" => end_of_term})
    |> Client.handle_response()
    |> maybe_log_message()
  end

  #
  # Private functions
  #

  @spec maybe_log_message({:ok, map} | {:error, term}) :: {:ok, map} | {:error, term}
  defp maybe_log_message({:ok, _response} = result) do
    Logger.info("Cancelled subscription on Chargebee")

    result
  end

  defp maybe_log_message(
         {:error,
          %Tesla.Env{
            body: %{"error_code" => "invalid_state_for_cancel", "error_msg" => error_msg}
          }}
       ) do
    Logger.error("Subscription in the wrong status for cancel: #{error_msg}")

    {:ok, %{}}
  end

  defp maybe_log_message(result), do: result
end
