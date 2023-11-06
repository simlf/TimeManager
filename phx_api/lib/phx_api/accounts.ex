defmodule TimeManager.Accounts do
  @moduledoc """
  The Accounts context.
  """

  import Ecto.Query, warn: false
  alias TimeManager.Repo

  alias TimeManager.Accounts.{User, UserToken}
  ## Database getters

  defp base_query() do
    from(u in User)
  end

  def list_users(username, email) do
    query = base_query()

    if username != "" do
      IO.inspect("DANS IF")
      IO.inspect(email)
      query = query
      |> where([u], u.username == ^username)
      Repo.all(query)
    else
      Repo.all(query)
    end
    # def get_tasks_by_user_id(idUser) do
    #   Repo.all(from(t in Task, where: t.user_id == ^idUser))
    # end
  end

  @doc """
  Gets a user by email.

  ## Examples

      iex> get_user_by_email("foo@example.com")
      %User{}

      iex> get_user_by_email("unknown@example.com")
      nil

  """
  def get_user_by_email(email) when is_binary(email) do
    Repo.get_by(User, email: email)
  end

  @doc """
  Gets a user by email and password.

  ## Examples

      iex> get_user_by_email_and_password("foo@example.com", "correct_password")
      %User{}

      iex> get_user_by_email_and_password("foo@example.com", "invalid_password")
      nil

  """
  def get_user_by_email_and_password(email, password)
      when is_binary(email) and is_binary(password) do
    user = Repo.get_by(User, email: email)
    if User.valid_password?(user, password), do: user
  end

  @doc """
  Gets a single user.

  Raises `Ecto.NoResultsError` if the User does not exist.

  ## Examples

      iex> get_user!(123)
      %User{}

      iex> get_user!(456)
      ** (Ecto.NoResultsError)

  """
  def get_user!(id), do: Repo.get!(User, id)

  ## User registration

  @doc """
  Registers a user.

  ## Examples

      iex> register_user(%{field: value})
      {:ok, %User{}}

      iex> register_user(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def register_user(attrs) do
    %User{}
    |> User.registration_changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  User update himself.

  ## Examples

      iex> update_me_user(user, %{field: new_value})
      {:ok, %Clock{}}

      iex> update_me_user(user, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_me_user(%User{} = user, attrs) do
    email = Map.get(attrs, "email", user.email)
    username = Map.get(attrs, "username", user.username)

    user
    |> User.user_update_changeset_himself(%{email: email, username: username})
    |> Repo.update()
  end

  @doc """
  Updates a user.

  ## Examples

      iex> update_user(user, %{field: new_value})
      {:ok, %Clock{}}

      iex> update_user(user, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_user(%User{} = user, attrs) do
    email = Map.get(attrs, "email", user.email)
    username = Map.get(attrs, "username", user.username)
    role = Map.get(attrs, "role", user.role)
    group_id = Map.get(attrs, "group_id", user.group_id)

    user
    |> User.user_update_changeset(%{email: email, username: username, role: role, group_id: group_id})
    |> Repo.update()
  end


  # def update_user_group_id(%User{} = user, user_params) do
  #   user
  #   |> User.changeset(user_params)
  #   |> Repo.update()
  # end

  @doc """
  Updates a user.

  ## Examples

      iex> update_user_password(user, %{field: new_value})
      {:ok, %Clock{}}

      iex> update_user_password(user, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_user_password(%User{} = user, attrs) do
    user
    |> User.password_changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Remove the group_id if group is delete
  """
  def remove_group_id(group_id) do
    query =
      from(u in User,
        where: u.group_id == ^group_id
      )
    users = Repo.all(query)

    Enum.each(users, fn user ->
      user
      |> User.user_remove_group_id(%{group_id: nil})
      |> Repo.update()
    end)
  end

  @doc """
  Deletes a user.

  ## Examples

      iex> delete_user(user)
      {:ok, %User{}}

      iex> delete_user(user)
      {:error, %Ecto.Changeset{}}

  """
  def delete_user(%User{} = user) do
    Repo.delete(user)
  end

  ## Session

    @doc """
  Generates a session token.
  """
  def generate_user_session_token(user) do
    {token, user_token} = UserToken.build_session_token(user)
    IO.inspect(user_token)
    Repo.insert!(user_token)
    token
  end

  @doc """
  Gets the user with the given signed token.
  """
  def get_user_by_session_token(token) do
    {:ok, query} = UserToken.verify_session_token_query(token)
    Repo.one(query)
  end

  @doc """
  Deletes the signed token with the given context.
  """
  def delete_user_session_token(token) do
    Repo.delete_all(UserToken.token_and_context_query(token, "session"))
    :ok
  end

#  def get_group_manager(user) do
#    group =
#      from(g in Group,
#        where: g.manager_ids == ^user.id,
#        select: g
#      )
#    |> TimeManager.Repo.one()
#
#    case group do
#      %Group{} = group -> group.manager_ids
#      _ -> nil
#    end
#  end

end
