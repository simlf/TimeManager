# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     TimeManager.Repo.insert!(%TimeManager.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.
# priv/repo/seeds/seed.exs

alias TimeManager.Repo
alias TimeManager.Accounts.User
alias TimeManager.Accounts
alias TimeManager.Groups.Group
alias TimeManager.Groups.Group_managers
alias TimeManager.Groups.Group_users
alias TimeManager.Clocks.Clock
alias TimeManager.Workingtime.Workingtimes

users = [
  %{username: "The patron", password: "PatronPassword", email: "patron@gotham.com", role: "SUPER_MANAGER"},
  %{username: "The patron 2", password: "PatronPassword", email: "patron2@gotham.com", role: "SUPER_MANAGER"},
  %{username: "The manager", password: "ManagerPassword", email: "manager@gotham.com", role: "MANAGER", group_id: 1},
  %{username: "The manager 2", password: "ManagerPassword", email: "manager2@gotham.com", role: "MANAGER", group_id: 1},
  %{username: "The employee", password: "EmployeePassword", email: "employee@gotham.com", role: "EMPLOYEE"},
  %{username: "The employee 2", password: "EmployeePassword", email: "employee2@gotham.com", role: "EMPLOYEE"},
  %{username: "User2", password: "password2", email: "user2@example.com", role: "EMPLOYEE"},
  %{username: "User3", password: "password3", email: "user3@example.com", role: "EMPLOYEE", group_id: 1},
  %{username: "User4", password: "password4", email: "user4@example.com", role: "EMPLOYEE", group_id: 1},
  %{username: "User5", password: "password5", email: "user5@example.com", role: "EMPLOYEE"},
]

# Insert users
Repo.transaction(fn ->
  Enum.each(users, fn user_params ->
    user = %User{}
    |> User.registration_changeset_seeds(user_params)
    |> Repo.insert()
    case user do
      {:ok, _} -> IO.puts("User created successfully")
      {:error, changeset} -> IO.inspect(changeset.errors)
    end
  end)
end)


groups = [
  %{name: "Joker lover"},
  %{name: "Batman lover"},
]

Repo.transaction(fn ->
  Enum.each(groups, fn groups_params ->
    group = %Group{}
            |> Group.register_group(groups_params)
            |> Repo.insert()
    case group do
      {:ok, _} -> IO.puts("Group created successfully")
      {:error, changeset} -> IO.inspect(changeset.errors)
    end
  end)
end)

group_users = [
  %{group_id: 1, user_id: 9},
  %{group_id: 1, user_id: 8},
]

# Insert group_users
Repo.transaction(fn ->
  Enum.each(group_users, fn group_users_params ->
    inject = %Group_users{}
             |> Group_users.changeset(group_users_params)
             |> Repo.insert()
    case inject do
      {:ok, _} -> IO.puts("Users add in group successfully")
      {:error, changeset} -> IO.inspect(changeset.errors)
    end
  end)
end)

group_managers = [
  %{group_id: 1, user_id: 3},
  %{group_id: 1, user_id: 4},
]

# Insert group_managers
Repo.transaction(fn ->
  Enum.each(group_managers, fn group_managers_params ->
    inject = %Group_managers{}
             |> Group_managers.changeset(group_managers_params)
             |> Repo.insert()
    case inject do
      {:ok, _} -> IO.puts("Users add in group successfully")
      {:error, changeset} -> IO.inspect(changeset.errors)
    end
  end)
end)

IO.puts("Manager add in group successfully")

clocks = [
  %{time: "2023-11-02 08:30:00", status: false, user_id: 1},
  %{time: "2023-11-02 09:00:00", status: false, user_id: 2},
  %{time: "2023-11-02 09:30:00", status: false, user_id: 3},
  %{time: "2023-11-02 09:00:00", status: false, user_id: 4},
  %{time: "2023-11-02 10:30:00", status: false, user_id: 5},
  %{time: "2023-11-02 09:00:00", status: false, user_id: 6},
  %{time: "2023-11-02 08:30:00", status: false, user_id: 7},
  %{time: "2023-11-02 12:00:00", status: false, user_id: 8},
  %{time: "2023-11-02 09:30:00", status: false, user_id: 9},
  %{time: "2023-11-02 08:00:00", status: false, user_id: 10}
]

# Insert clocks
Repo.transaction(fn ->
  Enum.each(clocks, fn clock_params ->
    clock = %Clock{}
    |> Clock.changeset(clock_params)
    |> Repo.insert()
    case clock do
      {:ok, _} -> IO.puts("Clock created successfully")
      {:error, changeset} -> IO.inspect(changeset.errors)
    end
  end)
end)

IO.puts("Clocks seeds inserted successfully")

workingTimes = [
#   %{start_time
%{start_time: "2023-10-31T07:07:00Z", end_time: "2023-10-31T10:40:00Z", user_id: 5, is_pause: false, type: "start_work"},
%{start_time: "2023-10-31T10:40:00Z", end_time: "2023-10-31T11:15:00Z", user_id: 5, is_pause: true, type: "pause"},
%{start_time: "2023-10-31T11:15:00Z", end_time: "2023-10-31T13:36:00Z", user_id: 5, is_pause: false, type: "basic_work"},
%{start_time: "2023-10-31T13:36:00Z", end_time: "2023-10-31T14:08:00Z", user_id: 5, is_pause: true, type: "pause"},
%{start_time: "2023-10-31T14:08:00Z", end_time: "2023-10-31T16:56:00Z", user_id: 5, is_pause: false, type: "end_work"},

%{start_time: "2023-11-02T09:00:00Z", end_time: "2023-11-02T10:11:00Z", user_id: 5, is_pause: false, type: "start_work"},
%{start_time: "2023-11-02T10:11:00Z", end_time: "2023-11-02T11:47:00Z", user_id: 5, is_pause: true, type: "pause"},
%{start_time: "2023-11-02T11:47:00Z", end_time: "2023-11-02T13:42:00Z", user_id: 5, is_pause: false, type: "basic_work"},
%{start_time: "2023-11-02T13:42:00Z", end_time: "2023-11-02T14:07:00Z", user_id: 5, is_pause: true, type: "pause"},
%{start_time: "2023-11-02T14:07:00Z", end_time: "2023-11-02T18:47:00Z", user_id: 5, is_pause: false, type: "end_work"},

%{start_time: "2023-11-03T08:04:00Z", end_time: "2023-11-03T10:04:00Z", user_id: 5, is_pause: false, type: "start_work"},
%{start_time: "2023-11-03T10:04:00Z", end_time: "2023-11-03T11:55:00Z", user_id: 5, is_pause: true, type: "pause"},
%{start_time: "2023-11-03T11:55:00Z", end_time: "2023-11-03T12:42:00Z", user_id: 5, is_pause: false, type: "basic_work"},
%{start_time: "2023-11-03T12:42:00Z", end_time: "2023-11-03T14:19:00Z", user_id: 5, is_pause: true, type: "pause"},
%{start_time: "2023-11-03T14:19:00Z", end_time: "2023-11-03T17:19:00Z", user_id: 5, is_pause: false, type: "end_work"},

%{start_time: "2023-11-06T08:35:00Z", end_time: "2023-11-06T10:32:00Z", user_id: 5, is_pause: false, type: "start_work"},
%{start_time: "2023-11-06T10:32:00Z", end_time: "2023-11-06T11:25:00Z", user_id: 5, is_pause: true, type: "pause"},
%{start_time: "2023-11-06T11:25:00Z", end_time: "2023-11-06T13:31:00Z", user_id: 5, is_pause: false, type: "basic_work"},
%{start_time: "2023-11-06T13:31:00Z", end_time: "2023-11-06T14:59:00Z", user_id: 5, is_pause: true, type: "pause"},
%{start_time: "2023-11-06T14:59:00Z", end_time: "2023-11-06T18:54:00Z", user_id: 5, is_pause: false, type: "end_work"},

%{start_time: "2023-11-07T08:17:00Z", end_time: "2023-11-07T10:17:00Z", user_id: 5, is_pause: false, type: "start_work"},
%{start_time: "2023-11-07T10:17:00Z", end_time: "2023-11-07T11:47:00Z", user_id: 5, is_pause: true, type: "pause"},
%{start_time: "2023-11-07T11:47:00Z", end_time: "2023-11-07T13:59:00Z", user_id: 5, is_pause: false, type: "basic_work"},
%{start_time: "2023-11-07T13:59:00Z", end_time: "2023-11-07T14:00:00Z", user_id: 5, is_pause: true, type: "pause"},
%{start_time: "2023-11-07T14:00:00Z", end_time: "2023-11-07T18:48:00Z", user_id: 5, is_pause: false, type: "end_work"},

%{start_time: "2023-11-08T09:53:00Z", end_time: "2023-11-08T10:08:00Z", user_id: 5, is_pause: false, type: "start_work"},
%{start_time: "2023-11-08T10:08:00Z", end_time: "2023-11-08T11:34:00Z", user_id: 5, is_pause: true, type: "pause"},
%{start_time: "2023-11-08T11:34:00Z", end_time: "2023-11-08T13:06:00Z", user_id: 5, is_pause: false, type: "basic_work"},
%{start_time: "2023-11-08T13:06:00Z", end_time: "2023-11-08T14:31:00Z", user_id: 5, is_pause: true, type: "pause"},
%{start_time: "2023-11-08T14:31:00Z", end_time: "2023-11-08T17:36:00Z", user_id: 5, is_pause: false, type: "end_work"},

%{start_time: "2023-11-09T09:11:00Z", end_time: "2023-11-09T10:24:00Z", user_id: 5, is_pause: false, type: "start_work"},
%{start_time: "2023-11-09T10:24:00Z", end_time: "2023-11-09T11:33:00Z", user_id: 5, is_pause: true, type: "pause"},
%{start_time: "2023-11-09T11:33:00Z", end_time: "2023-11-09T13:41:00Z", user_id: 5, is_pause: false, type: "basic_work"},
%{start_time: "2023-11-09T13:41:00Z", end_time: "2023-11-09T14:21:00Z", user_id: 5, is_pause: true, type: "pause"},
%{start_time: "2023-11-09T14:21:00Z", end_time: "2023-11-09T17:59:00Z", user_id: 5, is_pause: false, type: "end_work"},

%{start_time: "2023-11-10T07:53:00Z", end_time: "2023-11-10T10:46:00Z", user_id: 5, is_pause: false, type: "start_work"},
%{start_time: "2023-11-10T10:46:00Z", end_time: "2023-11-10T11:35:00Z", user_id: 5, is_pause: true, type: "pause"},
%{start_time: "2023-11-10T11:35:00Z", end_time: "2023-11-10T13:53:00Z", user_id: 5, is_pause: false, type: "basic_work"},
%{start_time: "2023-11-10T13:53:00Z", end_time: "2023-11-10T14:15:00Z", user_id: 5, is_pause: true, type: "pause"},
%{start_time: "2023-11-10T14:15:00Z", end_time: "2023-11-10T17:11:00Z", user_id: 5, is_pause: false, type: "end_work"},

%{start_time: "2023-10-31T08:14:00Z", end_time: "2023-10-31T10:41:00Z", user_id: 3, is_pause: false, type: "start_work"},
%{start_time: "2023-10-31T10:41:00Z", end_time: "2023-10-31T11:43:00Z", user_id: 3, is_pause: true, type: "pause"},
%{start_time: "2023-10-31T11:43:00Z", end_time: "2023-10-31T12:22:00Z", user_id: 3, is_pause: false, type: "basic_work"},
%{start_time: "2023-10-31T12:22:00Z", end_time: "2023-10-31T13:50:00Z", user_id: 3, is_pause: true, type: "pause"},
%{start_time: "2023-10-31T13:50:00Z", end_time: "2023-10-31T17:40:00Z", user_id: 3, is_pause: false, type: "end_work"},

%{start_time: "2023-11-02T07:05:00Z", end_time: "2023-11-02T10:53:00Z", user_id: 3, is_pause: false, type: "start_work"},
%{start_time: "2023-11-02T10:53:00Z", end_time: "2023-11-02T11:35:00Z", user_id: 3, is_pause: true, type: "pause"},
%{start_time: "2023-11-02T11:35:00Z", end_time: "2023-11-02T13:30:00Z", user_id: 3, is_pause: false, type: "basic_work"},
%{start_time: "2023-11-02T13:30:00Z", end_time: "2023-11-02T14:41:00Z", user_id: 3, is_pause: true, type: "pause"},
%{start_time: "2023-11-02T14:41:00Z", end_time: "2023-11-02T18:33:00Z", user_id: 3, is_pause: false, type: "end_work"},

%{start_time: "2023-11-03T09:40:00Z", end_time: "2023-11-03T10:29:00Z", user_id: 3, is_pause: false, type: "start_work"},
%{start_time: "2023-11-03T10:29:00Z", end_time: "2023-11-03T11:33:00Z", user_id: 3, is_pause: true, type: "pause"},
%{start_time: "2023-11-03T11:33:00Z", end_time: "2023-11-03T13:55:00Z", user_id: 3, is_pause: false, type: "basic_work"},
%{start_time: "2023-11-03T13:55:00Z", end_time: "2023-11-03T14:34:00Z", user_id: 3, is_pause: true, type: "pause"},
%{start_time: "2023-11-03T14:34:00Z", end_time: "2023-11-03T18:13:00Z", user_id: 3, is_pause: false, type: "end_work"},

%{start_time: "2023-11-06T07:55:00Z", end_time: "2023-11-06T10:40:00Z", user_id: 3, is_pause: false, type: "start_work"},
%{start_time: "2023-11-06T10:40:00Z", end_time: "2023-11-06T11:15:00Z", user_id: 3, is_pause: true, type: "pause"},
%{start_time: "2023-11-06T11:15:00Z", end_time: "2023-11-06T13:52:00Z", user_id: 3, is_pause: false, type: "basic_work"},
%{start_time: "2023-11-06T13:52:00Z", end_time: "2023-11-06T14:16:00Z", user_id: 3, is_pause: true, type: "pause"},
%{start_time: "2023-11-06T14:16:00Z", end_time: "2023-11-06T18:42:00Z", user_id: 3, is_pause: false, type: "end_work"},

%{start_time: "2023-11-07T09:15:00Z", end_time: "2023-11-07T10:12:00Z", user_id: 3, is_pause: false, type: "start_work"},
%{start_time: "2023-11-07T10:12:00Z", end_time: "2023-11-07T11:12:00Z", user_id: 3, is_pause: true, type: "pause"},
%{start_time: "2023-11-07T11:12:00Z", end_time: "2023-11-07T12:10:00Z", user_id: 3, is_pause: false, type: "basic_work"},
%{start_time: "2023-11-07T12:10:00Z", end_time: "2023-11-07T13:34:00Z", user_id: 3, is_pause: true, type: "pause"},
%{start_time: "2023-11-07T13:34:00Z", end_time: "2023-11-07T17:52:00Z", user_id: 3, is_pause: false, type: "end_work"},

%{start_time: "2023-11-08T09:51:00Z", end_time: "2023-11-08T10:45:00Z", user_id: 3, is_pause: false, type: "start_work"},
%{start_time: "2023-11-08T10:45:00Z", end_time: "2023-11-08T11:29:00Z", user_id: 3, is_pause: true, type: "pause"},
%{start_time: "2023-11-08T11:29:00Z", end_time: "2023-11-08T13:17:00Z", user_id: 3, is_pause: false, type: "basic_work"},
%{start_time: "2023-11-08T13:17:00Z", end_time: "2023-11-08T14:06:00Z", user_id: 3, is_pause: true, type: "pause"},
%{start_time: "2023-11-08T14:06:00Z", end_time: "2023-11-08T17:00:00Z", user_id: 3, is_pause: false, type: "end_work"},

%{start_time: "2023-11-09T09:48:00Z", end_time: "2023-11-09T10:15:00Z", user_id: 3, is_pause: false, type: "start_work"},
%{start_time: "2023-11-09T10:15:00Z", end_time: "2023-11-09T11:38:00Z", user_id: 3, is_pause: true, type: "pause"},
%{start_time: "2023-11-09T11:38:00Z", end_time: "2023-11-09T12:33:00Z", user_id: 3, is_pause: false, type: "basic_work"},
%{start_time: "2023-11-09T12:33:00Z", end_time: "2023-11-09T13:06:00Z", user_id: 3, is_pause: true, type: "pause"},
%{start_time: "2023-11-09T13:06:00Z", end_time: "2023-11-09T17:31:00Z", user_id: 3, is_pause: false, type: "end_work"},

%{start_time: "2023-11-10T08:49:00Z", end_time: "2023-11-10T10:52:00Z", user_id: 3, is_pause: false, type: "start_work"},
%{start_time: "2023-11-10T10:52:00Z", end_time: "2023-11-10T11:16:00Z", user_id: 3, is_pause: true, type: "pause"},
%{start_time: "2023-11-10T11:16:00Z", end_time: "2023-11-10T12:38:00Z", user_id: 3, is_pause: false, type: "basic_work"},
%{start_time: "2023-11-10T12:38:00Z", end_time: "2023-11-10T14:60:00Z", user_id: 3, is_pause: true, type: "pause"},
%{start_time: "2023-11-10T14:60:00Z", end_time: "2023-11-10T18:02:00Z", user_id: 3, is_pause: false, type: "end_work"},

%{start_time: "2023-10-31T07:15:00Z", end_time: "2023-10-31T10:51:00Z", user_id: 6, is_pause: false, type: "start_work"},
%{start_time: "2023-10-31T10:51:00Z", end_time: "2023-10-31T11:49:00Z", user_id: 6, is_pause: true, type: "pause"},
%{start_time: "2023-10-31T11:49:00Z", end_time: "2023-10-31T13:40:00Z", user_id: 6, is_pause: false, type: "basic_work"},
%{start_time: "2023-10-31T13:40:00Z", end_time: "2023-10-31T14:23:00Z", user_id: 6, is_pause: true, type: "pause"},
%{start_time: "2023-10-31T14:23:00Z", end_time: "2023-10-31T16:05:00Z", user_id: 6, is_pause: false, type: "end_work"},

%{start_time: "2023-11-02T07:16:00Z", end_time: "2023-11-02T10:19:00Z", user_id: 6, is_pause: false, type: "start_work"},
%{start_time: "2023-11-02T10:19:00Z", end_time: "2023-11-02T11:17:00Z", user_id: 6, is_pause: true, type: "pause"},
%{start_time: "2023-11-02T11:17:00Z", end_time: "2023-11-02T12:33:00Z", user_id: 6, is_pause: false, type: "basic_work"},
%{start_time: "2023-11-02T12:33:00Z", end_time: "2023-11-02T13:11:00Z", user_id: 6, is_pause: true, type: "pause"},
%{start_time: "2023-11-02T13:11:00Z", end_time: "2023-11-02T17:50:00Z", user_id: 6, is_pause: false, type: "end_work"},

%{start_time: "2023-11-03T09:33:00Z", end_time: "2023-11-03T10:48:00Z", user_id: 6, is_pause: false, type: "start_work"},
%{start_time: "2023-11-03T10:48:00Z", end_time: "2023-11-03T11:03:00Z", user_id: 6, is_pause: true, type: "pause"},
%{start_time: "2023-11-03T11:03:00Z", end_time: "2023-11-03T13:32:00Z", user_id: 6, is_pause: false, type: "basic_work"},
%{start_time: "2023-11-03T13:32:00Z", end_time: "2023-11-03T14:50:00Z", user_id: 6, is_pause: true, type: "pause"},
%{start_time: "2023-11-03T14:50:00Z", end_time: "2023-11-03T18:37:00Z", user_id: 6, is_pause: false, type: "end_work"},

%{start_time: "2023-11-06T08:30:00Z", end_time: "2023-11-06T10:43:00Z", user_id: 6, is_pause: false, type: "start_work"},
%{start_time: "2023-11-06T10:43:00Z", end_time: "2023-11-06T11:28:00Z", user_id: 6, is_pause: true, type: "pause"},
%{start_time: "2023-11-06T11:28:00Z", end_time: "2023-11-06T13:35:00Z", user_id: 6, is_pause: false, type: "basic_work"},
%{start_time: "2023-11-06T13:35:00Z", end_time: "2023-11-06T14:29:00Z", user_id: 6, is_pause: true, type: "pause"},
%{start_time: "2023-11-06T14:29:00Z", end_time: "2023-11-06T18:49:00Z", user_id: 6, is_pause: false, type: "end_work"},

%{start_time: "2023-11-07T07:43:00Z", end_time: "2023-11-07T10:15:00Z", user_id: 6, is_pause: false, type: "start_work"},
%{start_time: "2023-11-07T10:15:00Z", end_time: "2023-11-07T11:02:00Z", user_id: 6, is_pause: true, type: "pause"},
%{start_time: "2023-11-07T11:02:00Z", end_time: "2023-11-07T13:56:00Z", user_id: 6, is_pause: false, type: "basic_work"},
%{start_time: "2023-11-07T13:56:00Z", end_time: "2023-11-07T14:17:00Z", user_id: 6, is_pause: true, type: "pause"},
%{start_time: "2023-11-07T14:17:00Z", end_time: "2023-11-07T17:33:00Z", user_id: 6, is_pause: false, type: "end_work"},

%{start_time: "2023-11-08T09:45:00Z", end_time: "2023-11-08T10:56:00Z", user_id: 6, is_pause: false, type: "start_work"},
%{start_time: "2023-11-08T10:56:00Z", end_time: "2023-11-08T11:34:00Z", user_id: 6, is_pause: true, type: "pause"},
%{start_time: "2023-11-08T11:34:00Z", end_time: "2023-11-08T12:43:00Z", user_id: 6, is_pause: false, type: "basic_work"},
%{start_time: "2023-11-08T12:43:00Z", end_time: "2023-11-08T14:22:00Z", user_id: 6, is_pause: true, type: "pause"},
%{start_time: "2023-11-08T14:22:00Z", end_time: "2023-11-08T17:09:00Z", user_id: 6, is_pause: false, type: "end_work"},

%{start_time: "2023-11-09T07:18:00Z", end_time: "2023-11-09T10:41:00Z", user_id: 6, is_pause: false, type: "start_work"},
%{start_time: "2023-11-09T10:41:00Z", end_time: "2023-11-09T11:52:00Z", user_id: 6, is_pause: true, type: "pause"},
%{start_time: "2023-11-09T11:52:00Z", end_time: "2023-11-09T13:21:00Z", user_id: 6, is_pause: false, type: "basic_work"},
%{start_time: "2023-11-09T13:21:00Z", end_time: "2023-11-09T14:08:00Z", user_id: 6, is_pause: true, type: "pause"},
%{start_time: "2023-11-09T14:08:00Z", end_time: "2023-11-09T18:51:00Z", user_id: 6, is_pause: false, type: "end_work"},

%{start_time: "2023-11-10T09:47:00Z", end_time: "2023-11-10T10:31:00Z", user_id: 6, is_pause: false, type: "start_work"},
%{start_time: "2023-11-10T10:31:00Z", end_time: "2023-11-10T11:56:00Z", user_id: 6, is_pause: true, type: "pause"},
%{start_time: "2023-11-10T11:56:00Z", end_time: "2023-11-10T12:34:00Z", user_id: 6, is_pause: false, type: "basic_work"},
%{start_time: "2023-11-10T12:34:00Z", end_time: "2023-11-10T13:55:00Z", user_id: 6, is_pause: true, type: "pause"},
%{start_time: "2023-11-10T13:55:00Z", end_time: "2023-11-10T16:29:00Z", user_id: 6, is_pause: false, type: "end_work"},

%{start_time: "2023-10-31T09:11:00Z", end_time: "2023-10-31T10:22:00Z", user_id: 7, is_pause: false, type: "start_work"},
%{start_time: "2023-10-31T10:22:00Z", end_time: "2023-10-31T11:25:00Z", user_id: 7, is_pause: true, type: "pause"},
%{start_time: "2023-10-31T11:25:00Z", end_time: "2023-10-31T12:44:00Z", user_id: 7, is_pause: false, type: "basic_work"},
%{start_time: "2023-10-31T12:44:00Z", end_time: "2023-10-31T13:51:00Z", user_id: 7, is_pause: true, type: "pause"},
%{start_time: "2023-10-31T13:51:00Z", end_time: "2023-10-31T16:47:00Z", user_id: 7, is_pause: false, type: "end_work"},

%{start_time: "2023-11-02T08:12:00Z", end_time: "2023-11-02T10:25:00Z", user_id: 7, is_pause: false, type: "start_work"},
%{start_time: "2023-11-02T10:25:00Z", end_time: "2023-11-02T11:45:00Z", user_id: 7, is_pause: true, type: "pause"},
%{start_time: "2023-11-02T11:45:00Z", end_time: "2023-11-02T12:60:00Z", user_id: 7, is_pause: false, type: "basic_work"},
%{start_time: "2023-11-02T12:60:00Z", end_time: "2023-11-02T14:10:00Z", user_id: 7, is_pause: true, type: "pause"},
%{start_time: "2023-11-02T14:10:00Z", end_time: "2023-11-02T16:41:00Z", user_id: 7, is_pause: false, type: "end_work"},

%{start_time: "2023-11-03T07:14:00Z", end_time: "2023-11-03T10:03:00Z", user_id: 7, is_pause: false, type: "start_work"},
%{start_time: "2023-11-03T10:03:00Z", end_time: "2023-11-03T11:27:00Z", user_id: 7, is_pause: true, type: "pause"},
%{start_time: "2023-11-03T11:27:00Z", end_time: "2023-11-03T13:23:00Z", user_id: 7, is_pause: false, type: "basic_work"},
%{start_time: "2023-11-03T13:23:00Z", end_time: "2023-11-03T14:09:00Z", user_id: 7, is_pause: true, type: "pause"},
%{start_time: "2023-11-03T14:09:00Z", end_time: "2023-11-03T18:41:00Z", user_id: 7, is_pause: false, type: "end_work"},

%{start_time: "2023-11-06T08:38:00Z", end_time: "2023-11-06T10:50:00Z", user_id: 7, is_pause: false, type: "start_work"},
%{start_time: "2023-11-06T10:50:00Z", end_time: "2023-11-06T11:53:00Z", user_id: 7, is_pause: true, type: "pause"},
%{start_time: "2023-11-06T11:53:00Z", end_time: "2023-11-06T13:26:00Z", user_id: 7, is_pause: false, type: "basic_work"},
%{start_time: "2023-11-06T13:26:00Z", end_time: "2023-11-06T14:04:00Z", user_id: 7, is_pause: true, type: "pause"},
%{start_time: "2023-11-06T14:04:00Z", end_time: "2023-11-06T17:09:00Z", user_id: 7, is_pause: false, type: "end_work"},

%{start_time: "2023-11-07T08:14:00Z", end_time: "2023-11-07T10:58:00Z", user_id: 7, is_pause: false, type: "start_work"},
%{start_time: "2023-11-07T10:58:00Z", end_time: "2023-11-07T11:29:00Z", user_id: 7, is_pause: true, type: "pause"},
%{start_time: "2023-11-07T11:29:00Z", end_time: "2023-11-07T12:52:00Z", user_id: 7, is_pause: false, type: "basic_work"},
%{start_time: "2023-11-07T12:52:00Z", end_time: "2023-11-07T13:45:00Z", user_id: 7, is_pause: true, type: "pause"},
%{start_time: "2023-11-07T13:45:00Z", end_time: "2023-11-07T17:26:00Z", user_id: 7, is_pause: false, type: "end_work"},

%{start_time: "2023-11-08T07:60:00Z", end_time: "2023-11-08T10:11:00Z", user_id: 7, is_pause: false, type: "start_work"},
%{start_time: "2023-11-08T10:11:00Z", end_time: "2023-11-08T11:24:00Z", user_id: 7, is_pause: true, type: "pause"},
%{start_time: "2023-11-08T11:24:00Z", end_time: "2023-11-08T12:22:00Z", user_id: 7, is_pause: false, type: "basic_work"},
%{start_time: "2023-11-08T12:22:00Z", end_time: "2023-11-08T13:56:00Z", user_id: 7, is_pause: true, type: "pause"},
%{start_time: "2023-11-08T13:56:00Z", end_time: "2023-11-08T18:34:00Z", user_id: 7, is_pause: false, type: "end_work"},

%{start_time: "2023-11-09T07:40:00Z", end_time: "2023-11-09T10:14:00Z", user_id: 7, is_pause: false, type: "start_work"},
%{start_time: "2023-11-09T10:14:00Z", end_time: "2023-11-09T11:17:00Z", user_id: 7, is_pause: true, type: "pause"},
%{start_time: "2023-11-09T11:17:00Z", end_time: "2023-11-09T12:37:00Z", user_id: 7, is_pause: false, type: "basic_work"},
%{start_time: "2023-11-09T12:37:00Z", end_time: "2023-11-09T13:49:00Z", user_id: 7, is_pause: true, type: "pause"},
%{start_time: "2023-11-09T13:49:00Z", end_time: "2023-11-09T17:29:00Z", user_id: 7, is_pause: false, type: "end_work"},

%{start_time: "2023-11-10T09:43:00Z", end_time: "2023-11-10T10:02:00Z", user_id: 7, is_pause: false, type: "start_work"},
%{start_time: "2023-11-10T10:02:00Z", end_time: "2023-11-10T11:21:00Z", user_id: 7, is_pause: true, type: "pause"},
%{start_time: "2023-11-10T11:21:00Z", end_time: "2023-11-10T12:36:00Z", user_id: 7, is_pause: false, type: "basic_work"},
%{start_time: "2023-11-10T12:36:00Z", end_time: "2023-11-10T13:01:00Z", user_id: 7, is_pause: true, type: "pause"},
%{start_time: "2023-11-10T13:01:00Z", end_time: "2023-11-10T18:34:00Z", user_id: 7, is_pause: false, type: "end_work"},

%{start_time: "2023-10-31T09:29:00Z", end_time: "2023-10-31T10:12:00Z", user_id: 8, is_pause: false, type: "start_work"},
%{start_time: "2023-10-31T10:12:00Z", end_time: "2023-10-31T11:45:00Z", user_id: 8, is_pause: true, type: "pause"},
%{start_time: "2023-10-31T11:45:00Z", end_time: "2023-10-31T13:07:00Z", user_id: 8, is_pause: false, type: "basic_work"},
%{start_time: "2023-10-31T13:07:00Z", end_time: "2023-10-31T14:29:00Z", user_id: 8, is_pause: true, type: "pause"},
%{start_time: "2023-10-31T14:29:00Z", end_time: "2023-10-31T16:46:00Z", user_id: 8, is_pause: false, type: "end_work"},

%{start_time: "2023-11-02T09:18:00Z", end_time: "2023-11-02T10:23:00Z", user_id: 8, is_pause: false, type: "start_work"},
%{start_time: "2023-11-02T10:23:00Z", end_time: "2023-11-02T11:43:00Z", user_id: 8, is_pause: true, type: "pause"},
%{start_time: "2023-11-02T11:43:00Z", end_time: "2023-11-02T12:02:00Z", user_id: 8, is_pause: false, type: "basic_work"},
%{start_time: "2023-11-02T12:02:00Z", end_time: "2023-11-02T14:22:00Z", user_id: 8, is_pause: true, type: "pause"},
%{start_time: "2023-11-02T14:22:00Z", end_time: "2023-11-02T16:58:00Z", user_id: 8, is_pause: false, type: "end_work"},

%{start_time: "2023-11-03T09:46:00Z", end_time: "2023-11-03T10:38:00Z", user_id: 8, is_pause: false, type: "start_work"},
%{start_time: "2023-11-03T10:38:00Z", end_time: "2023-11-03T11:36:00Z", user_id: 8, is_pause: true, type: "pause"},
%{start_time: "2023-11-03T11:36:00Z", end_time: "2023-11-03T13:46:00Z", user_id: 8, is_pause: false, type: "basic_work"},
%{start_time: "2023-11-03T13:46:00Z", end_time: "2023-11-03T14:53:00Z", user_id: 8, is_pause: true, type: "pause"},
%{start_time: "2023-11-03T14:53:00Z", end_time: "2023-11-03T18:04:00Z", user_id: 8, is_pause: false, type: "end_work"},

%{start_time: "2023-11-06T08:29:00Z", end_time: "2023-11-06T10:28:00Z", user_id: 8, is_pause: false, type: "start_work"},
%{start_time: "2023-11-06T10:28:00Z", end_time: "2023-11-06T11:08:00Z", user_id: 8, is_pause: true, type: "pause"},
%{start_time: "2023-11-06T11:08:00Z", end_time: "2023-11-06T13:05:00Z", user_id: 8, is_pause: false, type: "basic_work"},
%{start_time: "2023-11-06T13:05:00Z", end_time: "2023-11-06T14:46:00Z", user_id: 8, is_pause: true, type: "pause"},
%{start_time: "2023-11-06T14:46:00Z", end_time: "2023-11-06T18:23:00Z", user_id: 8, is_pause: false, type: "end_work"},

%{start_time: "2023-11-07T08:00:00Z", end_time: "2023-11-07T10:25:00Z", user_id: 8, is_pause: false, type: "start_work"},
%{start_time: "2023-11-07T10:25:00Z", end_time: "2023-11-07T11:41:00Z", user_id: 8, is_pause: true, type: "pause"},
%{start_time: "2023-11-07T11:41:00Z", end_time: "2023-11-07T13:56:00Z", user_id: 8, is_pause: false, type: "basic_work"},
%{start_time: "2023-11-07T13:56:00Z", end_time: "2023-11-07T14:55:00Z", user_id: 8, is_pause: true, type: "pause"},
%{start_time: "2023-11-07T14:55:00Z", end_time: "2023-11-07T17:10:00Z", user_id: 8, is_pause: false, type: "end_work"},

%{start_time: "2023-11-08T07:44:00Z", end_time: "2023-11-08T10:53:00Z", user_id: 8, is_pause: false, type: "start_work"},
%{start_time: "2023-11-08T10:53:00Z", end_time: "2023-11-08T11:37:00Z", user_id: 8, is_pause: true, type: "pause"},
%{start_time: "2023-11-08T11:37:00Z", end_time: "2023-11-08T13:60:00Z", user_id: 8, is_pause: false, type: "basic_work"},
%{start_time: "2023-11-08T13:60:00Z", end_time: "2023-11-08T14:02:00Z", user_id: 8, is_pause: true, type: "pause"},
%{start_time: "2023-11-08T14:02:00Z", end_time: "2023-11-08T18:57:00Z", user_id: 8, is_pause: false, type: "end_work"},

%{start_time: "2023-11-09T08:19:00Z", end_time: "2023-11-09T10:39:00Z", user_id: 8, is_pause: false, type: "start_work"},
%{start_time: "2023-11-09T10:39:00Z", end_time: "2023-11-09T11:34:00Z", user_id: 8, is_pause: true, type: "pause"},
%{start_time: "2023-11-09T11:34:00Z", end_time: "2023-11-09T12:16:00Z", user_id: 8, is_pause: false, type: "basic_work"},
%{start_time: "2023-11-09T12:16:00Z", end_time: "2023-11-09T13:51:00Z", user_id: 8, is_pause: true, type: "pause"},
%{start_time: "2023-11-09T13:51:00Z", end_time: "2023-11-09T17:13:00Z", user_id: 8, is_pause: false, type: "end_work"},

%{start_time: "2023-11-10T08:17:00Z", end_time: "2023-11-10T10:42:00Z", user_id: 8, is_pause: false, type: "start_work"},
%{start_time: "2023-11-10T10:42:00Z", end_time: "2023-11-10T11:47:00Z", user_id: 8, is_pause: true, type: "pause"},
%{start_time: "2023-11-10T11:47:00Z", end_time: "2023-11-10T12:26:00Z", user_id: 8, is_pause: false, type: "basic_work"},
%{start_time: "2023-11-10T12:26:00Z", end_time: "2023-11-10T13:33:00Z", user_id: 8, is_pause: true, type: "pause"},
%{start_time: "2023-11-10T13:33:00Z", end_time: "2023-11-10T18:52:00Z", user_id: 8, is_pause: false, type: "end_work"},

%{start_time: "2023-10-31T09:50:00Z", end_time: "2023-10-31T10:05:00Z", user_id: 9, is_pause: false, type: "start_work"},
%{start_time: "2023-10-31T10:05:00Z", end_time: "2023-10-31T11:41:00Z", user_id: 9, is_pause: true, type: "pause"},
%{start_time: "2023-10-31T11:41:00Z", end_time: "2023-10-31T13:20:00Z", user_id: 9, is_pause: false, type: "basic_work"},
%{start_time: "2023-10-31T13:20:00Z", end_time: "2023-10-31T14:20:00Z", user_id: 9, is_pause: true, type: "pause"},
%{start_time: "2023-10-31T14:20:00Z", end_time: "2023-10-31T16:47:00Z", user_id: 9, is_pause: false, type: "end_work"},

%{start_time: "2023-11-02T08:39:00Z", end_time: "2023-11-02T10:21:00Z", user_id: 9, is_pause: false, type: "start_work"},
%{start_time: "2023-11-02T10:21:00Z", end_time: "2023-11-02T11:39:00Z", user_id: 9, is_pause: true, type: "pause"},
%{start_time: "2023-11-02T11:39:00Z", end_time: "2023-11-02T13:03:00Z", user_id: 9, is_pause: false, type: "basic_work"},
%{start_time: "2023-11-02T13:03:00Z", end_time: "2023-11-02T14:51:00Z", user_id: 9, is_pause: true, type: "pause"},
%{start_time: "2023-11-02T14:51:00Z", end_time: "2023-11-02T18:19:00Z", user_id: 9, is_pause: false, type: "end_work"},

%{start_time: "2023-11-03T09:60:00Z", end_time: "2023-11-03T10:51:00Z", user_id: 9, is_pause: false, type: "start_work"},
%{start_time: "2023-11-03T10:51:00Z", end_time: "2023-11-03T11:33:00Z", user_id: 9, is_pause: true, type: "pause"},
%{start_time: "2023-11-03T11:33:00Z", end_time: "2023-11-03T12:39:00Z", user_id: 9, is_pause: false, type: "basic_work"},
%{start_time: "2023-11-03T12:39:00Z", end_time: "2023-11-03T13:31:00Z", user_id: 9, is_pause: true, type: "pause"},
%{start_time: "2023-11-03T13:31:00Z", end_time: "2023-11-03T17:49:00Z", user_id: 9, is_pause: false, type: "end_work"},

%{start_time: "2023-11-06T09:05:00Z", end_time: "2023-11-06T10:16:00Z", user_id: 9, is_pause: false, type: "start_work"},
%{start_time: "2023-11-06T10:16:00Z", end_time: "2023-11-06T11:60:00Z", user_id: 9, is_pause: true, type: "pause"},
%{start_time: "2023-11-06T11:60:00Z", end_time: "2023-11-06T12:28:00Z", user_id: 9, is_pause: false, type: "basic_work"},
%{start_time: "2023-11-06T12:28:00Z", end_time: "2023-11-06T13:11:00Z", user_id: 9, is_pause: true, type: "pause"},
%{start_time: "2023-11-06T13:11:00Z", end_time: "2023-11-06T16:20:00Z", user_id: 9, is_pause: false, type: "end_work"},

%{start_time: "2023-11-07T08:36:00Z", end_time: "2023-11-07T10:24:00Z", user_id: 9, is_pause: false, type: "start_work"},
%{start_time: "2023-11-07T10:24:00Z", end_time: "2023-11-07T11:04:00Z", user_id: 9, is_pause: true, type: "pause"},
%{start_time: "2023-11-07T11:04:00Z", end_time: "2023-11-07T13:24:00Z", user_id: 9, is_pause: false, type: "basic_work"},
%{start_time: "2023-11-07T13:24:00Z", end_time: "2023-11-07T14:47:00Z", user_id: 9, is_pause: true, type: "pause"},
%{start_time: "2023-11-07T14:47:00Z", end_time: "2023-11-07T17:06:00Z", user_id: 9, is_pause: false, type: "end_work"},

%{start_time: "2023-11-08T08:40:00Z", end_time: "2023-11-08T10:50:00Z", user_id: 9, is_pause: false, type: "start_work"},
%{start_time: "2023-11-08T10:50:00Z", end_time: "2023-11-08T11:27:00Z", user_id: 9, is_pause: true, type: "pause"},
%{start_time: "2023-11-08T11:27:00Z", end_time: "2023-11-08T12:56:00Z", user_id: 9, is_pause: false, type: "basic_work"},
%{start_time: "2023-11-08T12:56:00Z", end_time: "2023-11-08T13:03:00Z", user_id: 9, is_pause: true, type: "pause"},
%{start_time: "2023-11-08T13:03:00Z", end_time: "2023-11-08T17:40:00Z", user_id: 9, is_pause: false, type: "end_work"},

%{start_time: "2023-11-09T09:10:00Z", end_time: "2023-11-09T10:21:00Z", user_id: 9, is_pause: false, type: "start_work"},
%{start_time: "2023-11-09T10:21:00Z", end_time: "2023-11-09T11:20:00Z", user_id: 9, is_pause: true, type: "pause"},
%{start_time: "2023-11-09T11:20:00Z", end_time: "2023-11-09T13:54:00Z", user_id: 9, is_pause: false, type: "basic_work"},
%{start_time: "2023-11-09T13:54:00Z", end_time: "2023-11-09T14:33:00Z", user_id: 9, is_pause: true, type: "pause"},
%{start_time: "2023-11-09T14:33:00Z", end_time: "2023-11-09T17:37:00Z", user_id: 9, is_pause: false, type: "end_work"},

%{start_time: "2023-11-10T09:19:00Z", end_time: "2023-11-10T10:05:00Z", user_id: 9, is_pause: false, type: "start_work"},
%{start_time: "2023-11-10T10:05:00Z", end_time: "2023-11-10T11:49:00Z", user_id: 9, is_pause: true, type: "pause"},
%{start_time: "2023-11-10T11:49:00Z", end_time: "2023-11-10T12:48:00Z", user_id: 9, is_pause: false, type: "basic_work"},
%{start_time: "2023-11-10T12:48:00Z", end_time: "2023-11-10T13:47:00Z", user_id: 9, is_pause: true, type: "pause"},
%{start_time: "2023-11-10T13:47:00Z", end_time: "2023-11-10T18:30:00Z", user_id: 9, is_pause: false, type: "end_work"},

]

# Insert working times
Repo.transaction(fn ->
  Enum.each(workingTimes, fn workingTime_params ->
    workingTime = %Workingtimes{}
    |> Workingtimes.changeset(workingTime_params)
    |> Repo.insert()

    case workingTime do
      {:ok, _} -> IO.puts("WorkingTime created successfully")
      {:error, changeset} -> IO.inspect(changeset.errors)
    end
  end)
end)


IO.puts("WorkingTimes seeds inserted successfully")
