defmodule TimeManager.Groups.Group_users do
  use Ecto.Schema
  import Ecto.Changeset

  schema "group_users" do
    belongs_to :group, TimeManager.Groups.Group, foreign_key: :group_id
    belongs_to :user, TimeManager.Accounts.User, foreign_key: :user_id
  end

  @doc false
  def changeset(group, attrs) do
    group
    |> cast(attrs, [:group_id, :user_id])
    #    |> validate_required([:name, :manager_ids, :user_ids])
  end
end
