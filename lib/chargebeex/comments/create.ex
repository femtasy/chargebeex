defmodule Chargebeex.Comments.Create do
  @moduledoc """
  Module to manage Chargebee
  [comments](https://apidocs.chargebee.com/docs/api/comments).
  """

  require Logger

  alias Chargebeex.Client

  @doc """
  Create a new comment for an entity.

  https://apidocs.chargebee.com/docs/api/comments?prod_cat_ver=1#create_a_comment
  """
  @spec create_comment(
          entity_type :: String.t(),
          entity_id :: String.t(),
          comment :: String.t()
        ) :: {:ok, map} | {:error, term}
  def create_comment(entity_type, entity_id, comment) do
    Client.new()
    |> Tesla.post("/comments", %{
      "entity_id" => entity_id,
      "entity_type" => entity_type,
      "notes" => comment
    })
    |> Client.handle_response()
    |> maybe_log_message()
  end

  #
  # Private functions
  #

  @spec maybe_log_message({:ok, map} | {:error, term}) :: {:ok, map} | {:error, term}
  defp maybe_log_message(
         {:error,
          %Tesla.Env{
            body: %{"error_code" => error_code, "error_msg" => error_msg} = error_body
          }}
       ) do
    Logger.error("Error #{error_code} creating comment: #{error_msg}")

    {:ok, error_body}
  end

  defp maybe_log_message(result), do: result
end
