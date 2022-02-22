defmodule Chargebeex.Subscriptions.List do
  @moduledoc """
  Module that provides a function to list a charbebee [subscriptions](https://apidocs.chargebee.com/docs/api/subscriptions#list_subscriptions).
  """

  alias Chargebeex.Client

  @doc """
  Retrieves the list of subscriptions that matches the given filters in options.

  ## Examples
      iex> list(query: ["customer_id[is]": 1234, "status[is]": "active"])
      {:ok, %{"list" => []}}

  See: https://apidocs.chargebee.com/docs/api/subscriptions#list_subscriptions_customer_id
  """
  @spec list(query: keyword()) :: {:ok, map} | {:error, term}
  def list(query: query) do
    Client.new()
    |> Tesla.get("/subscriptions/", query: query)
    |> Client.handle_response()
  end
end
