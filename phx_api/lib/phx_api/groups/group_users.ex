defmodule TimeManager.Groups.Group_users do
  use Ecto.Schema
  import Ecto.Changeset
  import Ecto.Query, warn: false
  alias TimeManager.Repo

  schema "group_users" do
    belongs_to :group, TimeManager.Groups.Group, foreign_key: :group_id
    belongs_to :user, TimeManager.Accounts.User, foreign_key: :user_id
  end

  @doc false
  def changeset(group, attrs, opts \\ []) do
    group
    |> cast(attrs, [:group_id, :user_id])
    |> validate_user_is_employee(opts)
  end

  defp validate_user_is_employee(changeset, _opts) do
    user_id = get_field(changeset, :user_id)
    user = Repo.get(TimeManager.Accounts.User, user_id)
    IO.inspect(user)

    case user.role do
      :EMPLOYEE ->
        changeset
      _ ->
        add_error(changeset, :user_id, "L'utilisateur n'a pas le rôle de manager")
    end
  end
end
