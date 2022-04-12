defmodule Chargebeex.HostedPages.Checkout do
  @moduledoc """
  This module provides the functions to checkout a new subscription
  through [Chargebee
  API](https://apidocs.chargebee.com/docs/api/hosted_pages?prod_cat_ver=1&lang=curl#checkout_new_subscription).
  """
  require Logger

  alias Chargebeex.Client

  @typedoc """
  Optional fields to create the subscription:

  * `coupon_ids`: List of coupons ids or codes to be applied to the new
  subscription.
  * `trial_end`: The time at which the trial ends for this subscription. A value
  of `0` means the subscription will be activated immediately.
  """
  @type optional_fields :: [coupon_ids: list(String.t()), trial_end: non_neg_integer() | nil]

  @doc """
  Creates a checkout for the given customer for the given plan.
  """
  @spec create_checkout(
          plan_id :: String.t(),
          customer_id :: String.t(),
          email :: String.t(),
          locale :: String.t(),
          opts :: optional_fields()
        ) ::
          {:error, any} | {:ok, map()}
  def create_checkout(plan_id, customer_id, email, locale, opts \\ [])
      when is_binary(plan_id) and is_binary(customer_id) do
    body = build_body(plan_id, customer_id, email, locale, opts)

    Client.new()
    |> Tesla.post("/hosted_pages/checkout_new", body)
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
          locale :: String.t(),
          opts :: optional_fields()
        ) :: map()
  defp build_body(plan_id, customer_id, email, locale, opts) do
    coupon_ids_map =
      Keyword.get(opts, :coupon_ids, [])
      |> Enum.with_index()
      |> Enum.map(fn {coupon_id, index} ->
        {"coupon_ids[#{index}]", coupon_id}
      end)
      |> Enum.into(%{})

    trial_end = Keyword.get(opts, :trial_end, nil)

    %{
      "customer[id]": customer_id,
      "customer[email]": email,
      "customer[locale]": locale,
      "subscription[plan_id]": plan_id
    }
    |> Map.merge(coupon_ids_map)
    |> maybe_put_trial_end(trial_end)
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

  defp maybe_put_trial_end(map, nil), do: map

  defp maybe_put_trial_end(map, trial_end) do
    Map.put(map, "subscription[trial_end]", trial_end)
  end
end
