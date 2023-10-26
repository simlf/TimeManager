defmodule TimeManager.Workingtime.Workingtimes do
  use Ecto.Schema
  import Ecto.Changeset

  schema "workingtimes" do
    field :end, :utc_datetime
    field :start, :utc_datetime
    belongs_to :user, TimeManager.Accounts.User, foreign_key: :user_id
    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(workingtimes, attrs) do
    workingtimes
    |> cast(attrs, [:user_id, :start, :end])
    |> validate_required([:user_id ,:start, :end])
  end
end
