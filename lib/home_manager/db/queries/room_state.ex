defmodule HomeManager.Db.Queries.RoomState do
  import Ecto.Query
  alias HomeManager.Repo

  def fetch_room_id(room_name) do
    case HomeManager.Db.Schema.Rooms
         |> where(name: ^room_name)
         |> select([r], r.id)
         |> Repo.one() do
      nil -> {:error, :no_room}
      room_id -> {:ok, room_id}
    end
  end

  def fetch_room_state(room_id) do
    case HomeManager.Db.Schema.RoomState |> where(room_id: ^room_id) |> order_by(desc: :ts) |> first() |> Repo.one() do
      nil -> {:error, :no_state}
      state -> {:ok, state}
    end
  end
end
