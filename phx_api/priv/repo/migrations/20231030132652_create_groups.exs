defmodule TimeManager.Repo.Migrations.CreateGroups do
  use Ecto.Migration

  def change do
    create table(:groups) do
      add :name, :string
      add :users_id, {:array, :integer}, default: []
      add :manager_id, references(:users, on_delete: :nothing)
      timestamps(type: :utc_datetime)
    end

    create index(:groups, [:users_id])
    create index(:groups, [:manager_id])
  end
end
