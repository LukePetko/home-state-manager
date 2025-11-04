defmodule HomeManager.Db.Queries.GlobalState do
  import Ecto.Query
  alias HomeManager.Repo

  def fetch_global_state do
    case HomeManager.Db.Schema.GlobalState |> order_by(desc: :ts) |> first() |> Repo.one() do
      nil -> {:error, :no_state}
      state -> {:ok, state}
    end
  end
end
