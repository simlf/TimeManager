defmodule TimeManager.Clocks.Clock do
  use Ecto.Schema
  import Ecto.Changeset

  schema "clocks" do
    field :time, :naive_datetime
    field :status, :boolean
    belongs_to :user, TimeManager.Users.User, foreign_key: :user_id
    timestamps()
  end

  @required_fields ~w(time status user_id)a
  @optional_fields ~w()

  @doc false
  def changeset(clock, attrs) do
    clock
    |> cast(attrs, @required_fields, @optional_fields)
    |> validate_required(@required_fields)
    |> foreign_key_constraint(:user_id)
  end
end
