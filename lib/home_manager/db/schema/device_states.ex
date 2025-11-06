defmodule HomeManager.Db.Schema.DeviceStates do
  @moduledoc false
  use Ecto.Schema
  import Ecto.Changeset

  @foreign_key_type :binary_id

  schema "device_states" do
    field :value, :map
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
