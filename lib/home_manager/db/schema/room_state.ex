defmodule HomeManager.Db.Schema.RoomState do
  @moduledoc false
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id

  schema "room_state" do
    field :mode, :string
    field :scene, :string
    field :ts, :utc_datetime
    field :version, :integer
    belongs_to :rooms, HomeManager.Db.Schema.Rooms, foreign_key: :room_id
  end

  
  @doc false
  def changeset(schema, attrs) do
    schema
    |> cast(attrs, [:room_id, :mode, :scene, :ts, :version])
    |> validate_required([:room_id])
    
    
    |> foreign_key_constraint(:room_id)
  end

end
