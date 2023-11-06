defmodule TimeManager.Repo.Migrations.CreateWorkingtimes do
  use Ecto.Migration

  def change do
    create table(:workingtimes) do
      add :start_time, :utc_datetime
      add :end_time, :utc_datetime
      add :is_pause, :boolean
      add :user_id, references(:users, on_delete: :nothing)

      timestamps(type: :utc_datetime)
    end

    create index(:workingtimes, [:user_id])
  end
end
