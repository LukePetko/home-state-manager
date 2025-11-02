defmodule HomeManager.Mqtt.Handlers.HomeState do
  @moduledoc false

  import Ecto.Query
  alias HomeManager.MqttClient
  alias HomeManager.Repo
  alias HomeManager.Db.Schema.GlobalState

  def handle(payload) do
    current_state =
      GlobalState |> order_by(desc: :ts) |> first() |> Repo.one()

    payload = Jason.decode!(payload)

    if current_state.mode == payload["mode"] do
      IO.puts("No change in global state")
    else
      json_payload = Jason.encode!(payload)

      MqttClient.publish("home/global/state", json_payload, retain: true)

      new_state = %GlobalState{
        ts: DateTime.utc_now() |> DateTime.truncate(:second),
        mode: payload["mode"]
      }

      Repo.insert!(new_state)

      IO.puts("Published new global state #{new_state.mode}")
    end
  end
end
