defmodule HomeManager.Db.Schema.Presence do
  @moduledoc false
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id

  schema "presence" do
    field :state, :string
    field :source, :string
    field :ts, :utc_datetime
    field :version, :integer
    belongs_to :people, HomeManager.Db.Schema.People, foreign_key: :person_id
  end

  
  @doc false
  def changeset(schema, attrs) do
    schema
    |> cast(attrs, [:person_id, :state, :source, :ts, :version])
    |> validate_required([:person_id])
    
    
    |> foreign_key_constraint(:person_id)
  end

end
