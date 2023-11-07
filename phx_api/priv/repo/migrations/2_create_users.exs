defmodule TimeManager.Repo.Migrations.CreateUsersAuthTables do
  use Ecto.Migration

  def change do
    execute "CREATE EXTENSION IF NOT EXISTS citext", ""

    create table(:users) do
      add :email, :citext, null: false
      add :username, :string, null: false
      add :hashed_password, :string, null: false
      add :role, :string, default: "EMPLOYEE", null: false
      add :group_id, :integer

      timestamps(type: :utc_datetime)
    end

    create unique_index(:users, [:email, :username])

    create table(:users_tokens) do
      add :user_id, references(:users, on_delete: :delete_all), null: false
      add :token, :binary, null: false
      add :context, :string, null: false
      add :sent_to, :string
      timestamps(updated_at: false)
    end

    create index(:users_tokens, [:user_id])
    create unique_index(:users_tokens, [:context, :token])

    create table(:group_users) do
      add :group_id, references(:groups, on_delete: :delete_all)
      add :user_id, references(:users, on_delete: :delete_all)
    end

    create index(:group_users, [:group_id])
    create index(:group_users, [:user_id])

    create table(:group_managers) do
      add :group_id, references(:groups, on_delete: :delete_all)
      add :user_id, references(:users, on_delete: :delete_all)
    end

    create index(:group_managers, [:group_id])
    create index(:group_managers, [:user_id])
  end
end
