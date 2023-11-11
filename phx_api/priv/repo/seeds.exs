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

# workingTimes = [
#   %{start_time: "2023-10-31T08:05:00Z", end_time: "2023-10-31T10:22:00Z", user_id: 1, is_pause: false, type: "start_work"},
#   %{start_time: "2023-10-31T10:22:00Z", end_time: "2023-10-31T12:42:00Z", user_id: 1, is_pause: true, type: "pause"},
#   %{start_time: "2023-10-31T12:42:00Z", end_time: "2023-10-31T14:31:00Z", user_id: 1, is_pause: false, type: "basic_work"},
#   %{start_time: "2023-10-31T14:31:00Z", end_time: "2023-10-31T16:27:00Z", user_id: 1, is_pause: true, type: "pause"},
#   %{start_time: "2023-10-31T16:27:00Z", end_time: "2023-10-31T19:48:00Z", user_id: 1, is_pause: false, type: "end_work"},

#   %{start_time: "2023-11-03T07:00:00Z", end_time: "2023-11-03T08:30:00Z", user_id: 1, is_pause: false, type: "start_work"},
#   %{start_time: "2023-11-03T08:30:00Z", end_time: "2023-11-03T09:00:00Z", user_id: 1, is_pause: true, type: "pause"},
#   %{start_time: "2023-11-03T09:00:00Z", end_time: "2023-11-03T12:00:00Z", user_id: 1, is_pause: false, type: "basic_work"},
#   %{start_time: "2023-11-03T12:00:00Z", end_time: "2023-11-03T13:00:00Z", user_id: 1, is_pause: true, type: "pause"},
#   %{start_time: "2023-11-03T13:00:00Z", end_time: "2023-11-03T17:00:00Z", user_id: 1, is_pause: false, type: "end_work"},

#   %{start_time: "2023-11-04T07:00:00Z", end_time: "2023-11-04T08:30:00Z", user_id: 1, is_pause: false, type: "start_work"},
#   %{start_time: "2023-11-04T08:30:00Z", end_time: "2023-11-04T09:00:00Z", user_id: 1, is_pause: true, type: "pause"},
#   %{start_time: "2023-11-04T09:00:00Z", end_time: "2023-11-04T12:00:00Z", user_id: 1, is_pause: false, type: "basic_work"},
#   %{start_time: "2023-11-04T12:00:00Z", end_time: "2023-11-04T13:00:00Z", user_id: 1, is_pause: true, type: "pause"},
#   %{start_time: "2023-11-04T13:00:00Z", end_time: "2023-11-04T17:00:00Z", user_id: 1, is_pause: false, type: "end_work"},

#   %{start_time: "2023-11-05T07:44:00Z", end_time: "2023-11-05T010:30:00Z", user_id: 1, is_pause: false, type: "start_work"},
#   %{start_time: "2023-11-05T10:30:00Z", end_time: "2023-11-05T10:57:00Z", user_id: 1, is_pause: true, type: "pause"},
#   %{start_time: "2023-11-05T10:57:00Z", end_time: "2023-11-05T13:00:00Z", user_id: 1, is_pause: false, type: "basic_work"},
#   %{start_time: "2023-11-05T13:00:00Z", end_time: "2023-11-05T14:00:00Z", user_id: 1, is_pause: true, type: "pause"},
#   %{start_time: "2023-11-05T14:00:00Z", end_time: "2023-11-05T17:00:00Z", user_id: 1, is_pause: false, type: "end_work"},

#   %{start_time: "2023-11-06T07:00:00Z", end_time: "2023-11-06T08:30:00Z", user_id: 1, is_pause: false, type: "start_work"},
#   %{start_time: "2023-11-06T08:30:00Z", end_time: "2023-11-06T09:00:00Z", user_id: 1, is_pause: true, type: "pause"},
#   %{start_time: "2023-11-06T09:00:00Z", end_time: "2023-11-06T12:00:00Z", user_id: 1, is_pause: false, type: "basic_work"},
#   %{start_time: "2023-11-06T12:00:00Z", end_time: "2023-11-06T13:00:00Z", user_id: 1, is_pause: true, type: "pause"},
#   %{start_time: "2023-11-06T13:00:00Z", end_time: "2023-11-06T17:00:00Z", user_id: 1, is_pause: false, type: "end_work"},
# ]

workingTimes = [

  %{start_time: "2023-10-31T09:16:00Z", end_time: "2023-10-31T10:43:00Z", user_id: 1, is_pause: false, type: "start_work"},
  %{start_time: "2023-10-31T10:43:00Z", end_time: "2023-10-31T11:36:00Z", user_id: 1, is_pause: true, type: "pause"},
  %{start_time: "2023-10-31T11:36:00Z", end_time: "2023-10-31T12:47:00Z", user_id: 1, is_pause: false, type: "basic_work"},
  %{start_time: "2023-10-31T12:47:00Z", end_time: "2023-10-31T14:30:00Z", user_id: 1, is_pause: true, type: "pause"},
  %{start_time: "2023-10-31T14:30:00Z", end_time: "2023-10-31T16:33:00Z", user_id: 1, is_pause: false, type: "end_work"},

  %{start_time: "2023-11-02T08:16:00Z", end_time: "2023-11-02T10:11:00Z", user_id: 1, is_pause: false, type: "start_work"},
  %{start_time: "2023-11-02T10:11:00Z", end_time: "2023-11-02T11:30:00Z", user_id: 1, is_pause: true, type: "pause"},
  %{start_time: "2023-11-02T11:30:00Z", end_time: "2023-11-02T12:12:00Z", user_id: 1, is_pause: false, type: "basic_work"},
  %{start_time: "2023-11-02T12:12:00Z", end_time: "2023-11-02T13:51:00Z", user_id: 1, is_pause: true, type: "pause"},
  %{start_time: "2023-11-02T13:51:00Z", end_time: "2023-11-02T18:00:00Z", user_id: 1, is_pause: false, type: "end_work"},

  %{start_time: "2023-11-03T07:40:00Z", end_time: "2023-11-03T10:00:00Z", user_id: 1, is_pause: false, type: "start_work"},
  %{start_time: "2023-11-03T10:00:00Z", end_time: "2023-11-03T11:46:00Z", user_id: 1, is_pause: true, type: "pause"},
  %{start_time: "2023-11-03T11:46:00Z", end_time: "2023-11-03T12:14:00Z", user_id: 1, is_pause: false, type: "basic_work"},
  %{start_time: "2023-11-03T12:14:00Z", end_time: "2023-11-03T14:02:00Z", user_id: 1, is_pause: true, type: "pause"},
  %{start_time: "2023-11-03T14:02:00Z", end_time: "2023-11-03T17:59:00Z", user_id: 1, is_pause: false, type: "end_work"},

  %{start_time: "2023-11-06T08:50:00Z", end_time: "2023-11-06T10:05:00Z", user_id: 1, is_pause: false, type: "start_work"},
  %{start_time: "2023-11-06T10:05:00Z", end_time: "2023-11-06T11:20:00Z", user_id: 1, is_pause: true, type: "pause"},
  %{start_time: "2023-11-06T11:20:00Z", end_time: "2023-11-06T12:26:00Z", user_id: 1, is_pause: false, type: "basic_work"},
  %{start_time: "2023-11-06T12:26:00Z", end_time: "2023-11-06T14:56:00Z", user_id: 1, is_pause: true, type: "pause"},
  %{start_time: "2023-11-06T14:56:00Z", end_time: "2023-11-06T18:58:00Z", user_id: 1, is_pause: false, type: "end_work"},

  %{start_time: "2023-11-07T08:16:00Z", end_time: "2023-11-07T10:58:00Z", user_id: 1, is_pause: false, type: "start_work"},
  %{start_time: "2023-11-07T10:58:00Z", end_time: "2023-11-07T11:52:00Z", user_id: 1, is_pause: true, type: "pause"},
  %{start_time: "2023-11-07T11:52:00Z", end_time: "2023-11-07T13:53:00Z", user_id: 1, is_pause: false, type: "basic_work"},
  %{start_time: "2023-11-07T13:53:00Z", end_time: "2023-11-07T14:39:00Z", user_id: 1, is_pause: true, type: "pause"},
  %{start_time: "2023-11-07T14:39:00Z", end_time: "2023-11-07T17:32:00Z", user_id: 1, is_pause: false, type: "end_work"},

  %{start_time: "2023-11-08T09:14:00Z", end_time: "2023-11-08T10:01:00Z", user_id: 1, is_pause: false, type: "start_work"},
  %{start_time: "2023-11-08T10:01:00Z", end_time: "2023-11-08T11:13:00Z", user_id: 1, is_pause: true, type: "pause"},
  %{start_time: "2023-11-08T11:13:00Z", end_time: "2023-11-08T13:43:00Z", user_id: 1, is_pause: false, type: "basic_work"},
  %{start_time: "2023-11-08T13:43:00Z", end_time: "2023-11-08T14:42:00Z", user_id: 1, is_pause: true, type: "pause"},
  %{start_time: "2023-11-08T14:42:00Z", end_time: "2023-11-08T16:35:00Z", user_id: 1, is_pause: false, type: "end_work"},

  %{start_time: "2023-11-09T07:28:00Z", end_time: "2023-11-09T10:49:00Z", user_id: 1, is_pause: false, type: "start_work"},
  %{start_time: "2023-11-09T10:49:00Z", end_time: "2023-11-09T11:58:00Z", user_id: 1, is_pause: true, type: "pause"},
  %{start_time: "2023-11-09T11:58:00Z", end_time: "2023-11-09T13:34:00Z", user_id: 1, is_pause: false, type: "basic_work"},
  %{start_time: "2023-11-09T13:34:00Z", end_time: "2023-11-09T14:51:00Z", user_id: 1, is_pause: true, type: "pause"},
  %{start_time: "2023-11-09T14:51:00Z", end_time: "2023-11-09T18:35:00Z", user_id: 1, is_pause: false, type: "end_work"},

  %{start_time: "2023-11-10T08:52:00Z", end_time: "2023-11-10T10:19:00Z", user_id: 1, is_pause: false, type: "start_work"},
  %{start_time: "2023-11-10T10:19:00Z", end_time: "2023-11-10T11:08:00Z", user_id: 1, is_pause: true, type: "pause"},
  %{start_time: "2023-11-10T11:08:00Z", end_time: "2023-11-10T12:55:00Z", user_id: 1, is_pause: false, type: "basic_work"},
  %{start_time: "2023-11-10T12:55:00Z", end_time: "2023-11-10T13:40:00Z", user_id: 1, is_pause: true, type: "pause"},
  %{start_time: "2023-11-10T13:40:00Z", end_time: "2023-11-10T18:37:00Z", user_id: 1, is_pause: false, type: "end_work"},

  %{start_time: "2023-10-31T07:31:00Z", end_time: "2023-10-31T10:39:00Z", user_id: 3, is_pause: false, type: "start_work"},
  %{start_time: "2023-10-31T10:39:00Z", end_time: "2023-10-31T11:39:00Z", user_id: 3, is_pause: true, type: "pause"},
  %{start_time: "2023-10-31T11:39:00Z", end_time: "2023-10-31T12:47:00Z", user_id: 3, is_pause: false, type: "basic_work"},
  %{start_time: "2023-10-31T12:47:00Z", end_time: "2023-10-31T14:21:00Z", user_id: 3, is_pause: true, type: "pause"},
  %{start_time: "2023-10-31T14:21:00Z", end_time: "2023-10-31T18:21:00Z", user_id: 3, is_pause: false, type: "end_work"},

  %{start_time: "2023-11-02T09:58:00Z", end_time: "2023-11-02T10:23:00Z", user_id: 3, is_pause: false, type: "start_work"},
  %{start_time: "2023-11-02T10:23:00Z", end_time: "2023-11-02T11:60:00Z", user_id: 3, is_pause: true, type: "pause"},
  %{start_time: "2023-11-02T11:60:00Z", end_time: "2023-11-02T13:33:00Z", user_id: 3, is_pause: false, type: "basic_work"},
  %{start_time: "2023-11-02T13:33:00Z", end_time: "2023-11-02T14:42:00Z", user_id: 3, is_pause: true, type: "pause"},
  %{start_time: "2023-11-02T14:42:00Z", end_time: "2023-11-02T17:16:00Z", user_id: 3, is_pause: false, type: "end_work"},

  %{start_time: "2023-11-03T09:44:00Z", end_time: "2023-11-03T10:33:00Z", user_id: 3, is_pause: false, type: "start_work"},
  %{start_time: "2023-11-03T10:33:00Z", end_time: "2023-11-03T11:20:00Z", user_id: 3, is_pause: true, type: "pause"},
  %{start_time: "2023-11-03T11:20:00Z", end_time: "2023-11-03T13:06:00Z", user_id: 3, is_pause: false, type: "basic_work"},
  %{start_time: "2023-11-03T13:06:00Z", end_time: "2023-11-03T14:54:00Z", user_id: 3, is_pause: true, type: "pause"},
  %{start_time: "2023-11-03T14:54:00Z", end_time: "2023-11-03T17:08:00Z", user_id: 3, is_pause: false, type: "end_work"},

  %{start_time: "2023-11-06T08:12:00Z", end_time: "2023-11-06T10:36:00Z", user_id: 3, is_pause: false, type: "start_work"},
  %{start_time: "2023-11-06T10:36:00Z", end_time: "2023-11-06T11:55:00Z", user_id: 3, is_pause: true, type: "pause"},
  %{start_time: "2023-11-06T11:55:00Z", end_time: "2023-11-06T12:27:00Z", user_id: 3, is_pause: false, type: "basic_work"},
  %{start_time: "2023-11-06T12:27:00Z", end_time: "2023-11-06T14:10:00Z", user_id: 3, is_pause: true, type: "pause"},
  %{start_time: "2023-11-06T14:10:00Z", end_time: "2023-11-06T17:17:00Z", user_id: 3, is_pause: false, type: "end_work"},

  %{start_time: "2023-11-07T09:22:00Z", end_time: "2023-11-07T10:00:00Z", user_id: 3, is_pause: false, type: "start_work"},
  %{start_time: "2023-11-07T10:00:00Z", end_time: "2023-11-07T11:16:00Z", user_id: 3, is_pause: true, type: "pause"},
  %{start_time: "2023-11-07T11:16:00Z", end_time: "2023-11-07T12:07:00Z", user_id: 3, is_pause: false, type: "basic_work"},
  %{start_time: "2023-11-07T12:07:00Z", end_time: "2023-11-07T13:14:00Z", user_id: 3, is_pause: true, type: "pause"},
  %{start_time: "2023-11-07T13:14:00Z", end_time: "2023-11-07T17:42:00Z", user_id: 3, is_pause: false, type: "end_work"},

  %{start_time: "2023-11-08T08:56:00Z", end_time: "2023-11-08T10:35:00Z", user_id: 3, is_pause: false, type: "start_work"},
  %{start_time: "2023-11-08T10:35:00Z", end_time: "2023-11-08T11:52:00Z", user_id: 3, is_pause: true, type: "pause"},
  %{start_time: "2023-11-08T11:52:00Z", end_time: "2023-11-08T13:28:00Z", user_id: 3, is_pause: false, type: "basic_work"},
  %{start_time: "2023-11-08T13:28:00Z", end_time: "2023-11-08T14:03:00Z", user_id: 3, is_pause: true, type: "pause"},
  %{start_time: "2023-11-08T14:03:00Z", end_time: "2023-11-08T18:06:00Z", user_id: 3, is_pause: false, type: "end_work"},

  %{start_time: "2023-11-09T08:05:00Z", end_time: "2023-11-09T10:09:00Z", user_id: 3, is_pause: false, type: "start_work"},
  %{start_time: "2023-11-09T10:09:00Z", end_time: "2023-11-09T11:24:00Z", user_id: 3, is_pause: true, type: "pause"},
  %{start_time: "2023-11-09T11:24:00Z", end_time: "2023-11-09T12:25:00Z", user_id: 3, is_pause: false, type: "basic_work"},
  %{start_time: "2023-11-09T12:25:00Z", end_time: "2023-11-09T14:52:00Z", user_id: 3, is_pause: true, type: "pause"},
  %{start_time: "2023-11-09T14:52:00Z", end_time: "2023-11-09T17:12:00Z", user_id: 3, is_pause: false, type: "end_work"},

  %{start_time: "2023-11-10T08:60:00Z", end_time: "2023-11-10T10:19:00Z", user_id: 3, is_pause: false, type: "start_work"},
  %{start_time: "2023-11-10T10:19:00Z", end_time: "2023-11-10T11:07:00Z", user_id: 3, is_pause: true, type: "pause"},
  %{start_time: "2023-11-10T11:07:00Z", end_time: "2023-11-10T13:13:00Z", user_id: 3, is_pause: false, type: "basic_work"},
  %{start_time: "2023-11-10T13:13:00Z", end_time: "2023-11-10T14:21:00Z", user_id: 3, is_pause: true, type: "pause"},
  %{start_time: "2023-11-10T14:21:00Z", end_time: "2023-11-10T18:06:00Z", user_id: 3, is_pause: false, type: "end_work"},

  %{start_time: "2023-10-31T07:43:00Z", end_time: "2023-10-31T10:33:00Z", user_id: 6, is_pause: false, type: "start_work"},
  %{start_time: "2023-10-31T10:33:00Z", end_time: "2023-10-31T11:27:00Z", user_id: 6, is_pause: true, type: "pause"},
  %{start_time: "2023-10-31T11:27:00Z", end_time: "2023-10-31T12:40:00Z", user_id: 6, is_pause: false, type: "basic_work"},
  %{start_time: "2023-10-31T12:40:00Z", end_time: "2023-10-31T14:12:00Z", user_id: 6, is_pause: true, type: "pause"},
  %{start_time: "2023-10-31T14:12:00Z", end_time: "2023-10-31T18:43:00Z", user_id: 6, is_pause: false, type: "end_work"},

  %{start_time: "2023-11-02T09:01:00Z", end_time: "2023-11-02T10:05:00Z", user_id: 6, is_pause: false, type: "start_work"},
  %{start_time: "2023-11-02T10:05:00Z", end_time: "2023-11-02T11:37:00Z", user_id: 6, is_pause: true, type: "pause"},
  %{start_time: "2023-11-02T11:37:00Z", end_time: "2023-11-02T13:57:00Z", user_id: 6, is_pause: false, type: "basic_work"},
  %{start_time: "2023-11-02T13:57:00Z", end_time: "2023-11-02T14:04:00Z", user_id: 6, is_pause: true, type: "pause"},
  %{start_time: "2023-11-02T14:04:00Z", end_time: "2023-11-02T18:16:00Z", user_id: 6, is_pause: false, type: "end_work"},

  %{start_time: "2023-11-03T07:19:00Z", end_time: "2023-11-03T10:19:00Z", user_id: 6, is_pause: false, type: "start_work"},
  %{start_time: "2023-11-03T10:19:00Z", end_time: "2023-11-03T11:47:00Z", user_id: 6, is_pause: true, type: "pause"},
  %{start_time: "2023-11-03T11:47:00Z", end_time: "2023-11-03T12:24:00Z", user_id: 6, is_pause: false, type: "basic_work"},
  %{start_time: "2023-11-03T12:24:00Z", end_time: "2023-11-03T14:56:00Z", user_id: 6, is_pause: true, type: "pause"},
  %{start_time: "2023-11-03T14:56:00Z", end_time: "2023-11-03T16:49:00Z", user_id: 6, is_pause: false, type: "end_work"},

  %{start_time: "2023-11-06T09:18:00Z", end_time: "2023-11-06T10:55:00Z", user_id: 6, is_pause: false, type: "start_work"},
  %{start_time: "2023-11-06T10:55:00Z", end_time: "2023-11-06T11:45:00Z", user_id: 6, is_pause: true, type: "pause"},
  %{start_time: "2023-11-06T11:45:00Z", end_time: "2023-11-06T13:48:00Z", user_id: 6, is_pause: false, type: "basic_work"},
  %{start_time: "2023-11-06T13:48:00Z", end_time: "2023-11-06T14:48:00Z", user_id: 6, is_pause: true, type: "pause"},
  %{start_time: "2023-11-06T14:48:00Z", end_time: "2023-11-06T18:58:00Z", user_id: 6, is_pause: false, type: "end_work"},

  %{start_time: "2023-11-07T08:14:00Z", end_time: "2023-11-07T10:46:00Z", user_id: 6, is_pause: false, type: "start_work"},
  %{start_time: "2023-11-07T10:46:00Z", end_time: "2023-11-07T11:35:00Z", user_id: 6, is_pause: true, type: "pause"},
  %{start_time: "2023-11-07T11:35:00Z", end_time: "2023-11-07T12:04:00Z", user_id: 6, is_pause: false, type: "basic_work"},
  %{start_time: "2023-11-07T12:04:00Z", end_time: "2023-11-07T13:13:00Z", user_id: 6, is_pause: true, type: "pause"},
  %{start_time: "2023-11-07T13:13:00Z", end_time: "2023-11-07T17:41:00Z", user_id: 6, is_pause: false, type: "end_work"},

  %{start_time: "2023-11-08T07:25:00Z", end_time: "2023-11-08T10:09:00Z", user_id: 6, is_pause: false, type: "start_work"},
  %{start_time: "2023-11-08T10:09:00Z", end_time: "2023-11-08T11:07:00Z", user_id: 6, is_pause: true, type: "pause"},
  %{start_time: "2023-11-08T11:07:00Z", end_time: "2023-11-08T12:43:00Z", user_id: 6, is_pause: false, type: "basic_work"},
  %{start_time: "2023-11-08T12:43:00Z", end_time: "2023-11-08T13:08:00Z", user_id: 6, is_pause: true, type: "pause"},
  %{start_time: "2023-11-08T13:08:00Z", end_time: "2023-11-08T17:43:00Z", user_id: 6, is_pause: false, type: "end_work"},

  %{start_time: "2023-11-09T07:46:00Z", end_time: "2023-11-09T10:06:00Z", user_id: 6, is_pause: false, type: "start_work"},
  %{start_time: "2023-11-09T10:06:00Z", end_time: "2023-11-09T11:58:00Z", user_id: 6, is_pause: true, type: "pause"},
  %{start_time: "2023-11-09T11:58:00Z", end_time: "2023-11-09T13:59:00Z", user_id: 6, is_pause: false, type: "basic_work"},
  %{start_time: "2023-11-09T13:59:00Z", end_time: "2023-11-09T14:18:00Z", user_id: 6, is_pause: true, type: "pause"},
  %{start_time: "2023-11-09T14:18:00Z", end_time: "2023-11-09T18:31:00Z", user_id: 6, is_pause: false, type: "end_work"},

  %{start_time: "2023-11-10T07:45:00Z", end_time: "2023-11-10T10:37:00Z", user_id: 6, is_pause: false, type: "start_work"},
  %{start_time: "2023-11-10T10:37:00Z", end_time: "2023-11-10T11:07:00Z", user_id: 6, is_pause: true, type: "pause"},
  %{start_time: "2023-11-10T11:07:00Z", end_time: "2023-11-10T12:49:00Z", user_id: 6, is_pause: false, type: "basic_work"},
  %{start_time: "2023-11-10T12:49:00Z", end_time: "2023-11-10T13:33:00Z", user_id: 6, is_pause: true, type: "pause"},
  %{start_time: "2023-11-10T13:33:00Z", end_time: "2023-11-10T17:31:00Z", user_id: 6, is_pause: false, type: "end_work"},

  %{start_time: "2023-10-31T07:10:00Z", end_time: "2023-10-31T10:21:00Z", user_id: 7, is_pause: false, type: "start_work"},
  %{start_time: "2023-10-31T10:21:00Z", end_time: "2023-10-31T11:31:00Z", user_id: 7, is_pause: true, type: "pause"},
  %{start_time: "2023-10-31T11:31:00Z", end_time: "2023-10-31T13:56:00Z", user_id: 7, is_pause: false, type: "basic_work"},
  %{start_time: "2023-10-31T13:56:00Z", end_time: "2023-10-31T14:47:00Z", user_id: 7, is_pause: true, type: "pause"},
  %{start_time: "2023-10-31T14:47:00Z", end_time: "2023-10-31T16:49:00Z", user_id: 7, is_pause: false, type: "end_work"},

  %{start_time: "2023-11-02T07:05:00Z", end_time: "2023-11-02T10:08:00Z", user_id: 7, is_pause: false, type: "start_work"},
  %{start_time: "2023-11-02T10:08:00Z", end_time: "2023-11-02T11:52:00Z", user_id: 7, is_pause: true, type: "pause"},
  %{start_time: "2023-11-02T11:52:00Z", end_time: "2023-11-02T13:25:00Z", user_id: 7, is_pause: false, type: "basic_work"},
  %{start_time: "2023-11-02T13:25:00Z", end_time: "2023-11-02T14:38:00Z", user_id: 7, is_pause: true, type: "pause"},
  %{start_time: "2023-11-02T14:38:00Z", end_time: "2023-11-02T16:05:00Z", user_id: 7, is_pause: false, type: "end_work"},

  %{start_time: "2023-11-03T09:47:00Z", end_time: "2023-11-03T10:45:00Z", user_id: 7, is_pause: false, type: "start_work"},
  %{start_time: "2023-11-03T10:45:00Z", end_time: "2023-11-03T11:37:00Z", user_id: 7, is_pause: true, type: "pause"},
  %{start_time: "2023-11-03T11:37:00Z", end_time: "2023-11-03T12:15:00Z", user_id: 7, is_pause: false, type: "basic_work"},
  %{start_time: "2023-11-03T12:15:00Z", end_time: "2023-11-03T13:24:00Z", user_id: 7, is_pause: true, type: "pause"},
  %{start_time: "2023-11-03T13:24:00Z", end_time: "2023-11-03T16:35:00Z", user_id: 7, is_pause: false, type: "end_work"},

  %{start_time: "2023-11-06T07:34:00Z", end_time: "2023-11-06T10:51:00Z", user_id: 7, is_pause: false, type: "start_work"},
  %{start_time: "2023-11-06T10:51:00Z", end_time: "2023-11-06T11:41:00Z", user_id: 7, is_pause: true, type: "pause"},
  %{start_time: "2023-11-06T11:41:00Z", end_time: "2023-11-06T13:11:00Z", user_id: 7, is_pause: false, type: "basic_work"},
  %{start_time: "2023-11-06T13:11:00Z", end_time: "2023-11-06T14:55:00Z", user_id: 7, is_pause: true, type: "pause"},
  %{start_time: "2023-11-06T14:55:00Z", end_time: "2023-11-06T18:14:00Z", user_id: 7, is_pause: false, type: "end_work"},

  %{start_time: "2023-11-07T07:25:00Z", end_time: "2023-11-07T10:55:00Z", user_id: 7, is_pause: false, type: "start_work"},
  %{start_time: "2023-11-07T10:55:00Z", end_time: "2023-11-07T11:49:00Z", user_id: 7, is_pause: true, type: "pause"},
  %{start_time: "2023-11-07T11:49:00Z", end_time: "2023-11-07T13:21:00Z", user_id: 7, is_pause: false, type: "basic_work"},
  %{start_time: "2023-11-07T13:21:00Z", end_time: "2023-11-07T14:54:00Z", user_id: 7, is_pause: true, type: "pause"},
  %{start_time: "2023-11-07T14:54:00Z", end_time: "2023-11-07T17:43:00Z", user_id: 7, is_pause: false, type: "end_work"},

  %{start_time: "2023-11-08T08:30:00Z", end_time: "2023-11-08T10:29:00Z", user_id: 7, is_pause: false, type: "start_work"},
  %{start_time: "2023-11-08T10:29:00Z", end_time: "2023-11-08T11:34:00Z", user_id: 7, is_pause: true, type: "pause"},
  %{start_time: "2023-11-08T11:34:00Z", end_time: "2023-11-08T13:07:00Z", user_id: 7, is_pause: false, type: "basic_work"},
  %{start_time: "2023-11-08T13:07:00Z", end_time: "2023-11-08T14:09:00Z", user_id: 7, is_pause: true, type: "pause"},
  %{start_time: "2023-11-08T14:09:00Z", end_time: "2023-11-08T16:31:00Z", user_id: 7, is_pause: false, type: "end_work"},

  %{start_time: "2023-11-09T09:20:00Z", end_time: "2023-11-09T10:30:00Z", user_id: 7, is_pause: false, type: "start_work"},
  %{start_time: "2023-11-09T10:30:00Z", end_time: "2023-11-09T11:22:00Z", user_id: 7, is_pause: true, type: "pause"},
  %{start_time: "2023-11-09T11:22:00Z", end_time: "2023-11-09T13:13:00Z", user_id: 7, is_pause: false, type: "basic_work"},
  %{start_time: "2023-11-09T13:13:00Z", end_time: "2023-11-09T14:54:00Z", user_id: 7, is_pause: true, type: "pause"},
  %{start_time: "2023-11-09T14:54:00Z", end_time: "2023-11-09T16:08:00Z", user_id: 7, is_pause: false, type: "end_work"},

  %{start_time: "2023-11-10T07:52:00Z", end_time: "2023-11-10T10:06:00Z", user_id: 7, is_pause: false, type: "start_work"},
  %{start_time: "2023-11-10T10:06:00Z", end_time: "2023-11-10T11:17:00Z", user_id: 7, is_pause: true, type: "pause"},
  %{start_time: "2023-11-10T11:17:00Z", end_time: "2023-11-10T13:42:00Z", user_id: 7, is_pause: false, type: "basic_work"},
  %{start_time: "2023-11-10T13:42:00Z", end_time: "2023-11-10T14:21:00Z", user_id: 7, is_pause: true, type: "pause"},
  %{start_time: "2023-11-10T14:21:00Z", end_time: "2023-11-10T16:02:00Z", user_id: 7, is_pause: false, type: "end_work"},

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
