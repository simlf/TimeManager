defmodule TimeManager.Groups.Group do
  use Ecto.Schema
  import Ecto.Changeset

  schema "groups" do
    field :name, :string
    has_many :users, TimeManager.Accounts.User
    has_many :managers, TimeManager.Accounts.User

    timestamps(type: :utc_datetime)
  end

  @doc false
  def register_group(group, attrs, opts \\ []) do
    group
    |> cast(attrs, [:name])
    |> validate_name(opts)
  end

  @doc false
  def changeset_update(group, attrs, opts \\ []) do
    group
    |> cast(attrs, [:name])
    |> validate_name(opts)
  end

  defp validate_name(changeset, opts) do
    changeset
    |> validate_required([:name])
    |> validate_length(:name, min: 4, max: 20)
    |> maybe_validate_unique_name(opts)
  end

  defp maybe_validate_unique_name(changeset, opts) do
    if Keyword.get(opts, :validate_name, true) do
      changeset
      |> unsafe_validate_unique(:name, TimeManager.Repo)
      |> unique_constraint(:name)
    else
      changeset
    end
  end

end