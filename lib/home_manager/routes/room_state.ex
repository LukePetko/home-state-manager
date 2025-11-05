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
      |> resp(200, Jason.encode!(state))
    else
      {:error, reason} ->
        send_resp(conn, 404, Jason.encode!(reason))
    end
  end
end
