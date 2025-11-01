defmodule HomeManager.Db.Schema.Devices do
  @moduledoc false
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :string, autogenerate: false}
  
  schema "devices" do
    field :type, :string
    field :name, :string
    # JSONB field - requires manual type specification based on your data:
# field :tags, :map                    # For JSON objects: {"key": "value"}
# field :tags, {:array, :string}       # For string arrays: ["value1", "value2"]
# field :tags, {:array, :integer}      # For integer arrays: [1, 2, 3]
# field :tags, {:array, :map}          # For object arrays: [{"id": 1}, {"id": 2}]

    # JSONB field - requires manual type specification based on your data:
# field :caps, :map                    # For JSON objects: {"key": "value"}
# field :caps, {:array, :string}       # For string arrays: ["value1", "value2"]
# field :caps, {:array, :integer}      # For integer arrays: [1, 2, 3]
# field :caps, {:array, :map}          # For object arrays: [{"id": 1}, {"id": 2}]

    # JSONB field - requires manual type specification based on your data:
# field :vendor, :map                    # For JSON objects: {"key": "value"}
# field :vendor, {:array, :string}       # For string arrays: ["value1", "value2"]
# field :vendor, {:array, :integer}      # For integer arrays: [1, 2, 3]
# field :vendor, {:array, :map}          # For object arrays: [{"id": 1}, {"id": 2}]

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
