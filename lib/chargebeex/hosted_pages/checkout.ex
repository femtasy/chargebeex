defmodule Chargebeex.HostedPages.Checkout do
  @moduledoc """
  This module provides the functions to checkout a new subscription
  through [Chargebee
  API](https://apidocs.chargebee.com/docs/api/hosted_pages?prod_cat_ver=1&lang=curl#checkout_new_subscription).
  """
  require Logger

  alias Chargebeex.Client

  @doc """
  Creates a checkout for the given customer for the given plan.
  """
  @spec create_checkout(
          plan_id :: String.t(),
          customer_id :: String.t(),
          email :: String.t(),
          locale :: String.t()
        ) ::
          {:error, any} | {:ok, map()}
  def create_checkout(plan_id, customer_id, email, locale) do
    Client.new()
    |> Tesla.post("/hosted_pages/checkout_new", build_body(plan_id, customer_id, email, locale))
    |> Client.handle_response()
    |> maybe_log_message()
  end

  #
  # Private functions
  #

  @spec build_body(
          plan_id :: String.t(),
          customer_id :: String.t(),
          email :: String.t(),
          locale :: String.t()
        ) :: map()
  defp build_body(plan_id, customer_id, email, locale) do
    %{
      "customer[id]": customer_id,
      "customer[email]": email,
      "customer[locale]": locale,
      "subscription[plan_id]": plan_id
    }
  end

  @spec maybe_log_message({:ok, map()} | {:error, any()}) :: {:error, any()} | {:ok, map()}
  defp maybe_log_message(
         {:error, %Tesla.Env{body: %{"error_code" => error_code, "error_msg" => error_msg}}}
       ) do
    error = "Error #{error_code} creating new checkout: #{error_msg}"

    Logger.error(error)

    {:error, error}
  end

  defp maybe_log_message(result), do: result
end
