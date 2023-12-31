defmodule TimeManager.Clocks.Clock do
  use Ecto.Schema
  import Ecto.Changeset

  schema "clocks" do
    field(:time, :naive_datetime)
    field(:status, :boolean)
    belongs_to(:user, TimeManager.Accounts.User, foreign_key: :user_id)

    timestamps()
  end

  @required_fields ~w(user_id)a
  @optional_fields ~w(time status)a

  @doc false
  def changeset(clock, attrs) do
    clock
    |> cast(attrs, @required_fields ++ @optional_fields)
    |> validate_required(@required_fields)
    |> unique_constraint(:user_id)
    |> foreign_key_constraint(:user_id)
  end

end
