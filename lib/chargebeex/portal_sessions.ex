defmodule Chargebeex.PortalSessions do
  @moduledoc """
  This module provides the functions  for [Chargebee portal sessions
  ](https://apidocs.chargebee.com/docs/api/portal_sessions?prod_cat_ver=1&lang=cur).
  """
  require Logger

  alias Chargebeex.PortalSessions.Create

  defmodule Behaviour do
    @moduledoc false

    @callback create(customer_id :: String.t()) ::
                {:error, any} | {:ok, map()}
  end

  @behaviour __MODULE__.Behaviour

  @impl __MODULE__.Behaviour
  defdelegate create(customer_id), to: Create
end
