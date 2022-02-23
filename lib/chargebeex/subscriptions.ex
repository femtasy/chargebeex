defmodule Chargebeex.Subscriptions do
  @moduledoc """
  Module that provides functions to handle Chargebee
  [Subscriptions](https://apidocs.chargebee.com/docs/api/subscriptions).
  """

  alias Chargebeex.Subscriptions.Cancel
  alias Chargebeex.Subscriptions.List
  alias Chargebeex.Subscriptions.Retrieve
  alias Chargebeex.Subscriptions.Update

  defmodule Behaviour do
    @moduledoc false

    @callback cancel_subscription(String.t(), keyword) :: {:ok, map} | {:error, term}

    @callback list(query: keyword()) :: {:ok, map} | {:error, term}

    @callback retrieve_subscription(String.t()) :: {:ok, map} | {:error, term}

    @callback update_subscription(subscription_id :: String.t(), map()) ::
                {:ok, map} | {:error, term}
  end

  @behaviour __MODULE__.Behaviour

  @impl __MODULE__.Behaviour
  defdelegate cancel_subscription(subscription_id, opts \\ []), to: Cancel

  @impl __MODULE__.Behaviour
  defdelegate list(query), to: List

  @impl __MODULE__.Behaviour
  defdelegate retrieve_subscription(subscription_id), to: Retrieve

  @impl __MODULE__.Behaviour
  defdelegate update_subscription(subscription_id, attrs), to: Update

  @doc """
  Returns the subscriptions wrapped in the _list_ key in a Chargebee response.

  This function does not run any validation on the subscriptions, it just
  returns the wrapped content.

  ## Examples

    iex> #{__MODULE__}.validate_subscriptions_response({:ok, %{"list" => ["subscription_1", "subscription_2"]}})
    ["subscription_1", "subscription_2"]

    iex> #{__MODULE__}.validate_subscriptions_response({:error, "an error"})
    {:error, "Error getting the subscriptions"}
  """
  @spec validate_subscriptions_response({:error, any()} | {:ok, map()}) ::
          {:error, String.t()} | list(map())
  def validate_subscriptions_response({:error, _}) do
    {:error, "Error getting the subscriptions"}
  end

  def validate_subscriptions_response({:ok, %{"list" => subscriptions}}) do
    subscriptions
  end

  @doc """
  Returns the subscriptions wrapped in the _subscription_ key.

  ### Examples

    iex> #{__MODULE__}.unwrap_subscriptions_response([%{"subscription" => %{"id" => 23}}, %{"subscription" => %{"id" => 5}}])
    [%{"id" => 23}, %{"id" => 5}]

    iex> #{__MODULE__}.unwrap_subscriptions_response({:error, "an error"})
    {:error, "an error"}
  """
  @spec unwrap_subscriptions_response({:error, any()} | list(map())) ::
          {:error, String.t()} | list(map())
  def unwrap_subscriptions_response({:error, _} = error), do: error

  def unwrap_subscriptions_response(subscriptions) do
    subscriptions
    |> Enum.reduce([], fn %{"subscription" => subscription}, acc ->
      [subscription | acc]
    end)
    |> Enum.reverse()
  end
end
