defmodule HomeManager.Db.Schema.Events do
  @moduledoc false
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :string, autogenerate: false}
  
  schema "events" do
    field :ts, :utc_datetime
    field :topic, :string
    # JSONB field - requires manual type specification based on your data:
# field :payload, :map                    # For JSON objects: {"key": "value"}
# field :payload, {:array, :string}       # For string arrays: ["value1", "value2"]
# field :payload, {:array, :integer}      # For integer arrays: [1, 2, 3]
# field :payload, {:array, :map}          # For object arrays: [{"id": 1}, {"id": 2}]

    # JSONB field - requires manual type specification based on your data:
# field :meta, :map                    # For JSON objects: {"key": "value"}
# field :meta, {:array, :string}       # For string arrays: ["value1", "value2"]
# field :meta, {:array, :integer}      # For integer arrays: [1, 2, 3]
# field :meta, {:array, :map}          # For object arrays: [{"id": 1}, {"id": 2}]

    field :kind, :string
  end

  
  @doc false
  def changeset(schema, attrs) do
    schema
    |> cast(attrs, [:ts, :topic, :payload, :meta, :kind])
    |> validate_required([:topic, :payload])
    
    
    
  end

end
