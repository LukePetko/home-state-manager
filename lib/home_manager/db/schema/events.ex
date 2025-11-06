defmodule HomeManager.Db.Schema.Events do
  @moduledoc false
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}

  schema "events" do
    field :ts, :utc_datetime
    field :topic, :string
    field :payload, :map
    field :meta, :map
    field :kind, :string
  end

  
  @doc false
  def changeset(schema, attrs) do
    schema
    |> cast(attrs, [:ts, :topic, :payload, :meta, :kind])
    |> validate_required([:topic, :payload])
    
    
    
  end

end
