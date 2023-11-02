defmodule TimeManagerWeb.GroupController do
  use TimeManagerWeb, :controller

  alias TimeManager.Groups
  alias TimeManager.Groups.Group
  alias TimeManager.Accounts.User
  alias TimeManager.Accounts

  action_fallback TimeManagerWeb.FallbackController

  def index(conn, _params) do
    groups = Groups.list_groups()
    render(conn, :index, groups: groups)
  end

  def create(conn, %{"group" => group_params}) do
    # Récupérez le manager_id à partir des paramètres du groupe
    manager_id = Map.get(group_params, "manager_id")
    IO.inspect(manager_id)

    # Assurez-vous que le manager_id est un entier valide
    with user = TimeManager.Accounts.get_user!(manager_id) do
      case user do
        %TimeManager.Accounts.User{roles: ["MANAGER"]} ->
          # L'utilisateur est un "MANAGER"
          case TimeManager.Accounts.get_group_manager(user) do
            nil ->
              user_id = user.id
              group_params = %{group_params | "user_ids" => [user_id | group_params["user_ids"]]}

              # Créez le groupe
              case Groups.create_group(group_params) do
                {:ok, %Group{} = group} ->
                  # Mettez à jour le champ group_id de l'utilisateur
                  user_params = %{"group_id" => group.id}

                  # Mettez à jour l'utilisateur dans la base de données
                  {:ok, updated_user} = TimeManager.Accounts.update_user(user, user_params)

                  conn
                  |> put_status(:created)
                  |> render(:show, group: group)
              end
            _ ->
              conn
              |> put_status(:forbidden)
              |> json(%{message: "L'utilisateur est déjà le manager d'une équipe."})
          end
        _ ->
          conn
          |> put_status(:forbidden)
          |> json(%{message: "Le manager_id doit appartenir à un utilisateur avec le rôle 'MANAGER'."})
      end
    else
      _ ->
        conn
        |> put_status(:forbidden)
        |> json(%{message: "Accès refusé pour les utilisateurs sans le rôle 'SUPER MANAGER'."})
    end
  end


  def show(conn, %{"id" => id}) do
    group = Groups.get_group!(id)
    render(conn, :show, group: group)
  end

  def update(conn, %{"id" => id, "group" => group_params}) do
    group = Groups.get_group!(id)

    with {:ok, %Group{} = group} <- Groups.update_group(group, group_params) do
      render(conn, :show, group: group)
    end
  end

  def delete(conn, %{"id" => id}) do
    group = Groups.get_group!(id)

    with {:ok, %Group{}} <- Groups.delete_group(group) do
      send_resp(conn, :no_content, "")
    end
  end
end
