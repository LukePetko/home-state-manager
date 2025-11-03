defmodule HomeManager.Mqtt.Handlers.Common do
  @moduledoc """
  Shared helper functions for MQTT handlers
  """

  def decode_payload(payload) when is_binary(payload), do: Jason.decode(payload)
  def decode_payload(payload) when is_map(payload), do: {:ok, payload}
end
