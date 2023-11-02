defmodule TimeManager.Repo.Migrations.AddGroupIdToUsers do
  use Ecto.Migration

  def change do
    alter table(:users) do
      add :group_id, references(:groups, on_delete: :nothing)
    end

  end
end
