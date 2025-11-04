defmodule HomeManager.Routes.GlobalState do
  use Plug.Router

  import HomeManager.Db.Queries.GlobalState

  plug(:match)
  plug(:dispatch)

  get "/" do
    case fetch_global_state() do
      {:ok, state} ->
        conn
        |> put_resp_header("content-type", "application/json")
        |> resp(200, decode_result(state))

      {:error, reason} ->
        send_resp(conn, 404, Jason.encode!(reason))
    end
  end

  defp decode_result(state) do
    state
    |> Map.take([:id, :mode, :ts])
    |> Jason.encode!()
  end
end
