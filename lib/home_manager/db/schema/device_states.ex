defmodule HomeManager.Db.Schema.DeviceStates do
  @moduledoc false
  use Ecto.Schema
  import Ecto.Changeset

  schema "device_states" do
    # JSONB field - requires manual type specification based on your data:
# field :value, :map                    # For JSON objects: {"key": "value"}
# field :value, {:array, :string}       # For string arrays: ["value1", "value2"]
# field :value, {:array, :integer}      # For integer arrays: [1, 2, 3]
# field :value, {:array, :map}          # For object arrays: [{"id": 1}, {"id": 2}]

    field :last_cmd_id, :string
    field :ts, :utc_datetime
    field :version, :integer
    belongs_to :devices, HomeManager.Db.Schema.Devices, foreign_key: :device_id
  end

  
  @doc false
  def changeset(schema, attrs) do
    schema
    |> cast(attrs, [:device_id, :value, :last_cmd_id, :ts, :version])
    |> validate_required([:device_id, :value])
    
    
    |> foreign_key_constraint(:device_id)
  end

end
