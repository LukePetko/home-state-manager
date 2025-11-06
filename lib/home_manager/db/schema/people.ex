defmodule HomeManager.Db.Schema.People do
  @moduledoc false
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  
  schema "people" do
    field :name, :string
    field :ha_person_id, :string
    field :created_at, :utc_datetime
    field :updated_at, :utc_datetime
    has_many :presence, HomeManager.Db.Schema.Presence, foreign_key: :person_id
  end

  
  @doc false
  def changeset(schema, attrs) do
    schema
    |> cast(attrs, [:name, :ha_person_id, :created_at, :updated_at])
    |> validate_required([:name])
    
    
    
  end

end
