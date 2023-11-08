defmodule TimeManagerWeb.GroupController do
  use TimeManagerWeb, :controller

  alias TimeManager.Groups
  alias TimeManager.Groups.Group
  alias TimeManager.Accounts
  alias TimeManager.Groups.Group_managers
  alias TimeManager.Groups.Group_users
  alias TimeManager.Repo

  action_fallback TimeManagerWeb.FallbackController

  def index(conn, _params) do
    groups = Groups.list_groups()
    render(conn, :index, groups: groups)
  end

  def create(conn, %{"group" => group_params}) do
    employees = Map.get(group_params, "employees", [])
    managers = Map.get(group_params, "managers", [])
    name = Map.get(group_params, "name")

    with {:ok, %Group{} = group} <- Groups.create_group(%{name: name}) do
      if managers != [] do
        insert_managers(managers, group.id)
      end

      if employees != [] do
        insert_employees(employees, group.id)
      end

      conn
      |> put_status(:created)
      |> render(:show, group: group)
    end
  end

  def show(conn, %{"id" => id}) do
    group_and_user = Groups.get_group_and_user(id)

    case group_and_user do
      nil ->
        conn
        |> put_status(:not_found)
        |> json(%{error: "Group not found"})
        |> halt()
      _ ->
        render(conn, :show_group_and_user, group_and_user: group_and_user)
    end
  end

  def update(conn, %{"id" => id, "group" => group_params}) do
    active_manager = conn.assigns[:current_user]
    group = Groups.get_group(id)

    case group do
      nil ->
        conn
        |> put_status(:not_found)
        |> json(%{error: "Group not found"})
        |> halt()
      _ ->
        employees = Map.get(group_params, "employees", [])
        managers = Map.get(group_params, "managers", [])
        name = Map.get(group_params, "name")

        with {:ok, %Group{} = group} <- Groups.update_group(group, %{name: name}) do
          if managers != [] && active_manager.role == :SUPER_MANAGER do
            insert_managers(managers, group.id)
          end
          if employees != [] do
            insert_employees(employees, group.id)
          end

          render(conn, "show.json", group: group)
        end
    end
  end

  def delete(conn, %{"id" => id}) do
    group = Groups.get_group(id)

    case group do
      nil ->
        conn
        |> put_status(:not_found)
        |> json(%{error: "Group not found"})
        |> halt()
      _ ->
        with {:ok, %Group{}} <- Groups.delete_group(group) do
          Accounts.remove_group_id(id)
          send_resp(conn, :no_content, "")
        end
    end
  end

  def insert_managers(manager_ids, group_id) do
    user_params = %{"group_id" => group_id}

    Enum.each(manager_ids, fn manager_id ->
      user = Accounts.get_user!(manager_id)
      case user do
        %TimeManager.Accounts.User{} = user ->
          case user.group_id do
            nil ->
              group_manager_params = %{group_id: group_id, user_id: user.id}
              changeset = %Group_managers{}
                          |> Group_managers.changeset(group_manager_params)

              case Repo.insert(changeset) do
                {:ok, _} ->
                  {:ok, updated_user} = TimeManager.Accounts.update_user(user, user_params)

                {:error, changeset} ->
                  IO.puts("Failed to create Group_manager.")
              end

            _ ->
              group_manager_params = %{group_id: group_id, user_id: user.id}
              line = Repo.get_by(Group_managers, user_id: user.id)

              changeset = line
                          |> Group_managers.changeset(group_manager_params)

              case Repo.update(changeset) do
                {:ok, _} ->
                  {:ok, updated_user} = TimeManager.Accounts.update_user(user, user_params)

                {:error, changeset} ->
                  IO.puts("Failed to update Group_manager.")
              end
          end

        nil ->
          IO.puts("User not found for ID: #{user.id}")
      end
    end)
  end

  def insert_employees(employee_ids, group_id) do
    user_params = %{"group_id" => group_id}

    Enum.each(employee_ids, fn employee_id ->
      user = Accounts.get_user!(employee_id)
      case user do
        %TimeManager.Accounts.User{} = user ->
          case user.group_id do
            nil ->
              group_user_params = %{group_id: group_id, user_id: user.id}
              changeset = %Group_users{}
                          |> Group_users.changeset(group_user_params)

              case Repo.insert(changeset) do
                {:ok, _} ->
                  {:ok, updated_user} = TimeManager.Accounts.update_user(user, user_params)

                {:error, changeset} ->
                  IO.puts("Failed to create Group_users.")
              end

            _ ->
              group_user_params = %{group_id: group_id, user_id: user.id}
              line = Repo.get_by(Group_users, user_id: user.id)

              changeset = line
                          |> Group_users.changeset(group_user_params)

              case Repo.update(changeset) do
                {:ok, _} ->
                  {:ok, updated_user} = TimeManager.Accounts.update_user(user, user_params)

                {:error, changeset} ->
                  IO.puts("Failed to update Group_users.")
              end
          end

        nil ->
          IO.puts("User not found for ID: #{user.id}")
      end
    end)
  end

end
