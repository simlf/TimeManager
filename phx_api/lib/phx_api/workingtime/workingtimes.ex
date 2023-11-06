defmodule TimeManager.Workingtime.Workingtimes do
  use Ecto.Schema
  import Ecto.Changeset

  schema "workingtimes" do
    field :end_time, :utc_datetime
    field :start_time, :utc_datetime
    field :is_pause, :boolean
    field(:type, Ecto.Enum, values: [:start_work, :end_work, :basic_work, :pause])

    belongs_to :user, TimeManager.Accounts.User, foreign_key: :user_id
    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(workingtimes, attrs) do
    workingtimes
    |> cast(attrs, [:user_id, :start_time, :end_time, :is_pause, :type])
    |> validate_required([:user_id, :start_time])
  end
end
