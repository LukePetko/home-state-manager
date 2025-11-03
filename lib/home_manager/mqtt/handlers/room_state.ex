defmodule HomeManager.Mqtt.Handlers.RoomState do
  @moduledoc """
  Handles room state changes
  """

  import Ecto.Query
  import HomeManager.Mqtt.Handlers.Common
  require Logger
  alias Ecto.Repo
  alias HomeManager.Db.Schema.{RoomState, Rooms}
  alias HomeManager.Repo
  alias HomeManager.MqttClient

  def handle(payload, room_name) do
    with {:ok, decoded_playload} <- decode_payload(payload),
         {:ok, room_id} <- fetch_room_id(room_name),
         {:ok, current_state} <- fetch_room_state(room_id),
         :ok <- validate_state_change(current_state, decoded_playload) do
      update_room_state(room_id, room_name, decoded_playload)
    else
      {:error, :no_room} ->
        Logger.error("No room found with name #{room_name}")
        {:error, :room_not_found}

      {:error, :no_change} ->
        Logger.info("No change in room state")
        :ok

      {:error, reason} = error ->
        Logger.error("An error occurred: #{inspect(reason)}")
        error
    end
  end

  defp fetch_room_id(room_name) do
    case Rooms
         |> where(name: ^room_name)
         |> select([r], r.id)
         |> Repo.one() do
      nil -> {:error, :no_room}
      room_id -> {:ok, room_id}
    end
  end

  defp fetch_room_state(room_id) do
    state =
      RoomState
      |> where(room_id: ^room_id)
      |> order_by(desc: :ts)
      |> first()
      |> Repo.one()

    {:ok, state}
  end

  defp validate_state_change(nil, _payload), do: :ok
  defp validate_state_change(%RoomState{mode: m}, %{"mode" => m}), do: {:error, :no_change}
  defp validate_state_change(_current_state, _payload), do: :ok

  defp update_room_state(room_id, room_name, payload) do
    Repo.transaction(fn ->
      json_payload = Jason.encode!(payload)
      MqttClient.publish("home/room/#{room_name}/state", json_payload, retain: true)

      new_state = %RoomState{
        ts: DateTime.utc_now() |> DateTime.truncate(:second),
        mode: payload["mode"],
        room_id: room_id
      }

      {:ok, inserted_state} = Repo.insert(new_state)

      {1, _} =
        Rooms
        |> where(id: ^room_id)
        |> Repo.update_all(set: [current_mode: payload["mode"]])

      Logger.info("Published new room #{room_name} state #{inserted_state.mode}")

      inserted_state
    end)

    :ok
  end
end
