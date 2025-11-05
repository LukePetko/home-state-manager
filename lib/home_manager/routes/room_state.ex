defmodule HomeManager.Routes.RoomState do
  use Plug.Router

  import HomeManager.Db.Queries.RoomState

  plug(:match)
  plug(:dispatch)

  get "/:room_name" do
    with {:ok, room_id} <- fetch_room_id(room_name),
         {:ok, state} <- fetch_room_state(room_id) do
      conn
      |> put_resp_header("content-type", "application/json")
      |> resp(200, decode_result(state, room_name))
    else
      {:error, reason} ->
        send_resp(conn, 404, Jason.encode!(reason))
    end
  end

  defp decode_result(state, room_name) do
    state
    |> Map.take([:id, :mode, :scene, :ts])
    |> Map.put(:room_name, room_name)
    |> Jason.encode!()
  end
end
