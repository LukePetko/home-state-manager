defmodule HomeManager.Db.Schema.Rooms do
  @moduledoc false
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  
  schema "rooms" do
    field :name, :string
    field :created_at, :utc_datetime
    field :current_mode, :string
    has_many :devices, HomeManager.Db.Schema.Devices, foreign_key: :room_id
    has_many :room_state, HomeManager.Db.Schema.RoomState, foreign_key: :room_id
  end

  
  @doc false
  def changeset(schema, attrs) do
    schema
    |> cast(attrs, [:name, :created_at, :current_mode])
    |> validate_required([:name])
    
    
    
  end

end
