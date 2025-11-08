defmodule HomeManager.Repo.Migrations.CreateDb do
  use Ecto.Migration

  def change do
    # Enable UUID extension
    execute "CREATE EXTENSION IF NOT EXISTS \"pgcrypto\"", "DROP EXTENSION IF EXISTS \"pgcrypto\""

    # Create people table
    create table(:people, primary_key: false) do
      add :id, :uuid, primary_key: true, default: fragment("gen_random_uuid()")
      add :name, :string, null: false
      add :ha_person_id, :string
      add :created_at, :utc_datetime
      add :updated_at, :utc_datetime
    end

    # Create rooms table
    create table(:rooms, primary_key: false) do
      add :id, :uuid, primary_key: true, default: fragment("gen_random_uuid()")
      add :name, :string, null: false
      add :created_at, :utc_datetime
      add :current_mode, :string
    end

    # Create devices table
    create table(:devices, primary_key: false) do
      add :id, :uuid, primary_key: true, default: fragment("gen_random_uuid()")
      add :type, :string
      add :name, :string
      add :tags, :map
      add :caps, :map
      add :vendor, :map
      add :created_at, :utc_datetime
      add :updated_at, :utc_datetime
      add :room_id, references(:rooms, type: :uuid, on_delete: :nothing)
    end

    create index(:devices, [:room_id])

    # Create events table
    create table(:events, primary_key: false) do
      add :id, :uuid, primary_key: true, default: fragment("gen_random_uuid()")
      add :ts, :utc_datetime
      add :topic, :string, null: false
      add :payload, :map, null: false
      add :meta, :map
      add :kind, :string
    end

    # Create device_states table
    create table(:device_states) do
      add :device_id, references(:devices, type: :uuid, on_delete: :nothing), null: false
      add :value, :map, null: false
      add :last_cmd_id, :string
      add :ts, :utc_datetime
      add :version, :integer
    end

    create index(:device_states, [:device_id])

    # Create global_state table
    create table(:global_state, primary_key: false) do
      add :id, :uuid, primary_key: true, default: fragment("gen_random_uuid()")
      add :mode, :string
      add :ts, :utc_datetime
    end

    # Create room_state table
    create table(:room_state, primary_key: false) do
      add :id, :uuid, primary_key: true, default: fragment("gen_random_uuid()")
      add :room_id, references(:rooms, type: :uuid, on_delete: :nothing), null: false
      add :mode, :string
      add :scene, :string
      add :ts, :utc_datetime
      add :version, :integer
    end

    create index(:room_state, [:room_id])

    # Create presence table
    create table(:presence, primary_key: false) do
      add :id, :uuid, primary_key: true, default: fragment("gen_random_uuid()")
      add :person_id, references(:people, type: :uuid, on_delete: :nothing), null: false
      add :state, :string
      add :source, :string
      add :ts, :utc_datetime
      add :version, :integer
    end

    create index(:presence, [:person_id])

    create table(:security, primary_key: false) do
      add :id, :uuid, primary_key: true, default: fragment("gen_random_uuid()")
      add :state, :string
      add :ts, :utc_datetime
      add :version, :integer
  end
end
