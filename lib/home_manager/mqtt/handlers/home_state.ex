defmodule HomeManager.Mqtt.Handlers.HomeState do
  @moduledoc """
  Handles global state changes
  """

  import Ecto.Query
  import HomeManager.Mqtt.Handlers.Common
  require Logger
  alias HomeManager.MqttClient
  alias HomeManager.Repo
  alias HomeManager.Db.Schema.GlobalState

  def handle(payload) do
    with {:ok, decoded_payload} <- decode_payload(payload),
         {:ok, mode} <- check_mode(decoded_payload) do
      handle_decoded(mode)
    else
      {:error, :missing_mode} ->
        Logger.error("Missing mode in payload")
        {:error, :missing_mode}

      {:error, reason} = error ->
        Logger.error("An error occurred: #{inspect(reason)}")
        error
    end
  end

  defp handle_decoded(mode) do
    with {:ok, current_state} <- fetch_global_state(),
         :ok <- validate_state_change(current_state, mode) do
      update_global_state(mode)
    else
      {:error, :no_state} ->
        Logger.info("No global state found, creating new one")
        update_global_state(mode)

      {:error, :no_change} ->
        Logger.info("No change in global state")
        :ok
    end
  end

  defp check_mode(%{"mode" => mode}), do: {:ok, mode}
  defp check_mode(_), do: {:error, :missing_mode}

  defp fetch_global_state do
    case GlobalState |> order_by(desc: :ts) |> first() |> Repo.one() do
      nil -> {:error, :no_state}
      state -> {:ok, state}
    end
  end

  defp validate_state_change(nil, _payload), do: :ok

  defp validate_state_change(%GlobalState{mode: m}, m), do: {:error, :no_change}

  defp validate_state_change(_current_state, _payload), do: :ok

  defp update_global_state(mode) do
    Repo.transaction(fn ->
      json_payload = Jason.encode!(%{"mode" => mode})
      MqttClient.publish("home/global/state", json_payload, retain: true)

      new_state = %GlobalState{
        ts: DateTime.utc_now() |> DateTime.truncate(:second),
        mode: mode
      }

      {:ok, inserted_state} = Repo.insert(new_state)

      Logger.info("Published new global state #{inserted_state.mode}")

      inserted_state
    end)

    :ok
  end
end
