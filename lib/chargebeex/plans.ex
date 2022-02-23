defmodule Chargebeex.Plans do
  @moduledoc """
  Module that provides functions to work with [Chargebee
  Plans](https://apidocs.chargebee.com/docs/api/plans).
  """

  alias Chargebeex.Plans.Retrieve

  defmodule Behaviour do
    @moduledoc false

    @callback retrieve(String.t()) :: {:ok, map()} | {:error, term()}
  end

  @behaviour __MODULE__.Behaviour

  @impl __MODULE__.Behaviour
  defdelegate retrieve(plan_id), to: Retrieve
end
