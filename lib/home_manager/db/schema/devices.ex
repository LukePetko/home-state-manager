defmodule HomeManager.Db.Schema.Devices do
  @moduledoc false
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id

  schema "devices" do
    field :type, :string
    field :name, :string
    field :tags, :map
    field :caps, :map
    field :vendor, :map
    field :created_at, :utc_datetime
    field :updated_at, :utc_datetime
    belongs_to :rooms, HomeManager.Db.Schema.Rooms, foreign_key: :room_id
    has_many :device_states, HomeManager.Db.Schema.DeviceStates, foreign_key: :device_id
  end

  
  @doc false
  def changeset(schema, attrs) do
    schema
    |> cast(attrs, [:room_id, :type, :name, :tags, :caps, :vendor, :created_at, :updated_at])
    
    
    
    |> foreign_key_constraint(:room_id)
  end

end
