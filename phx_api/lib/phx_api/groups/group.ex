defmodule TimeManager.Groups.Group do
  use Ecto.Schema
  import Ecto.Changeset

  schema "groups" do
    field :name, :string
    field :user_ids, {:array, :integer}, default: []
    field :manager_id, :id

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(group, attrs) do
    group
    |> cast(attrs, [:name, :manager_id, :user_ids])
    |> validate_required([:name, :manager_id, :user_ids])
    |> unique_constraint([:manager_id])
  end
end
