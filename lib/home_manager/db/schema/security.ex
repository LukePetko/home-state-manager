defmodule HomeManager.Db.Schema.Security do
  @moduledoc false
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id

  schema "security" do
    field :state, :string
    field :ts, :utc_datetime
    field :version, :integer
  end

  
  @doc false
  def changeset(schema, attrs) do
    schema
    |> cast(attrs, [:state, :ts, :version])
    |> validate_required([])
    
  end

end
