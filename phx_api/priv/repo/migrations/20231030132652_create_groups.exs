defmodule TimeManager.Repo.Migrations.CreateGroups do
  use Ecto.Migration

  def change do
    create table(:groups) do
      add :name, :string
      add :user_ids, {:array, :integer}, default: []
      add :manager_id, references(:users, on_delete: :nothing)
      timestamps(type: :utc_datetime)
    end

    create index(:groups, [:user_ids])
    create index(:groups, [:manager_id])
  end
end
