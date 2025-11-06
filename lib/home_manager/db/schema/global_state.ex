defmodule HomeManager.Db.Schema.GlobalState do
  @moduledoc false
  use Ecto.Schema
  import Ecto.Changeset
  
  @primary_key {:id, :binary_id, autogenerate: true}
  
  schema "global_state" do
    field :mode, :string
    field :ts, :utc_datetime
  end
  
  @doc false
  def changeset(schema, attrs) do
    schema
    |> cast(attrs, [:mode, :ts])
  end
end
