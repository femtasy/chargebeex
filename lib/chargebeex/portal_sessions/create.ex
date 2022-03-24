defmodule Chargebeex.PortalSessions.Create do
  @moduledoc """
  This module provides a function to create a Portal Sessions
  through [Chargebee
  API](https://apidocs.chargebee.com/docs/api/portal_sessions?prod_cat_ver=1&lang=curl).
  """
  require Logger

  alias Chargebeex.Client

  defmodule Behaviour do
    @moduledoc false

    @callback create(String.t()) :: {:ok, map()} | {:error, term()}
  end

  @doc """
  Creates a portal session for the given customer.
  """
  @spec create(customer_id :: String.t()) :: {:ok, map()} | {:error, any()}
  def create(customer_id) do
    Client.new()
    |> Tesla.post("portal_sessions", %{"customer[id]": customer_id})
    |> Client.handle_response()
    |> maybe_log_message()
  end

  @spec maybe_log_message({:ok, map()} | {:error, any()}) :: {:error, any()} | {:ok, map()}
  defp maybe_log_message(
         {:error, %Tesla.Env{body: %{"error_code" => error_code, "error_msg" => error_msg}}}
       ) do
    error = "Error #{error_code} creating portal session: #{error_msg}"

    Logger.error(error)

    {:error, error}
  end

  defp maybe_log_message(result), do: result
end
