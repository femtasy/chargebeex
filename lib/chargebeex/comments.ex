defmodule Chargebeex.Comments do
  @moduledoc """
  Module to manage Chargebee
  [comments](https://apidocs.chargebee.com/docs/api/comments).
  """

  require Logger

  alias Chargebeex.Comments.Create, as: CreateComment

  defmodule Behaviour do
    @moduledoc false

    @callback create_comment(
                entity_type :: String.t(),
                entity_id :: String.t(),
                comment :: String.t()
              ) :: {:ok, map} | {:error, term}
  end

  @behaviour __MODULE__.Behaviour

  @impl __MODULE__.Behaviour
  defdelegate create_comment(entity_type, entity_id, comment), to: CreateComment
end
