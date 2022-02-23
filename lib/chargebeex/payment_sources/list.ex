defmodule Chargebeex.PaymentSources.List do
  @moduledoc """
  Module that provides a function to list Chargebee [Payment
  Sources](https://apidocs.chargebee.com/docs/api/payment_sources#list_payment_sources).
  """

  alias Chargebeex.Client

  @doc """
  Retrieves the list of payment sources by the given customer_id.

  See: https://apidocs.chargebee.com/docs/api/payment_sources#list_payment_sources_customer_id
  """
  @spec by_customer_id(customer_id :: String.t()) ::
          {:ok, map} | {:error, term}
  def by_customer_id(customer_id) when is_binary(customer_id) do
    Client.new()
    |> Tesla.get("/payment_sources/", query: ["customer_id[is]": customer_id])
    |> Client.handle_response()
  end

  @doc """
  Filters the valid payment sources from the given list of payment sources.

  ## Examples
    iex> #{__MODULE__}.filter_valid_payment_sources([%{"payment_source"=> %{"id" => "23", "status" => "valid"}}])
    [%{"payment_source"=> %{"id" => "23", "status" => "valid"}}]

    iex> #{__MODULE__}.filter_valid_payment_sources([%{"payment_source"=> %{"id" => "5", "status" => "invalid"}}])
    []
  """
  @spec filter_valid_payment_sources(payment_sources :: list(map())) :: list(map())
  def filter_valid_payment_sources(payment_sources) do
    Enum.filter(payment_sources, fn %{"payment_source" => payment_source} ->
      payment_source["status"] == "valid"
    end)
  end
end
