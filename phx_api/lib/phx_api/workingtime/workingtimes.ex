defmodule TimeManager.Workingtime.Workingtimes do
  use Ecto.Schema
  import Ecto.Changeset

  schema "workingtimes" do
    field :end, :utc_datetime
    field :start, :utc_datetime
    belongs_to :user, TimeManager.Accounts.User
    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(workingtimes, attrs) do
    workingtimes
    |> cast(attrs, [:users, :start, :end])
    |> validate_required([:users ,:start, :end])
  end
end
