defmodule TimeManager.Groups.Group do
  use Ecto.Schema
  import Ecto.Changeset

  schema "groups" do
    field :name, :string
    field :users_id, {:array, :integer}, default: []
    field :manager_id, :id

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(group, attrs) do
    group
    |> cast(attrs, [:name, :manager_id, :users_id])
    |> validate_required([:name, :manager_id, :users_id])
    |> unique_constraint([:manager_id])
  end
end
