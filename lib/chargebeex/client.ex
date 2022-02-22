defmodule Chargebeex.Client do
  @moduledoc """
  This module provides common functions for the Chargebee Tesla Client.
  """

  @doc """
  Returns a new [Tesla client](`t:Tesla.Client.t/0`).

  The client provides a default list of middleware that can be extended passing
  a list to this function.

  ## Examples
      iex> #{__MODULE__}.new()
      %Tesla.Client{}
  """
  @spec new() :: Tesla.Client.t()
  def new() do
    max_request_retries = Application.get_env(:chargebeex, :max_request_retries, 3)

    middleware = [
      {Tesla.Middleware.BaseUrl, Chargebeex.base_url()},
      {Tesla.Middleware.BasicAuth, username: Chargebeex.api_key()},
      {Tesla.Middleware.Retry,
       max_retries: max_request_retries,
       should_retry: fn
         {:ok, %{status: status}} when status in [400, 500] -> true
         {:ok, _} -> false
         {:error, _} -> true
       end},
      Tesla.Middleware.FormUrlencoded,
      Tesla.Middleware.JSON
    ]

    Tesla.client(middleware)
  end

  @doc """
  Handles a Chargebee API response.

  https://apidocs.chargebee.com/docs/api#error_handling
  """
  @spec handle_response({:ok, Tesla.Env.result()} | {:error, any}) ::
          {:ok, any} | {:error, any}
  def handle_response(response) do
    case response do
      {:ok, %Tesla.Env{status: status_code, body: response}}
      when status_code >= 200 and status_code <= 299 ->
        {:ok, response}

      {:ok, %Tesla.Env{} = env} ->
        {:error, env}

      {:error, _reason} = error ->
        error
    end
  end
end
