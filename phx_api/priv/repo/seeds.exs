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
alias TimeManager.Groups.Group
alias TimeManager.Groups.Group_managers
alias TimeManager.Groups.Group_users
alias TimeManager.Clocks.Clock
alias TimeManager.Workingtime.Workingtimes

users = [
  %{username: "The patron", password: "PatronPassword", email: "patron@gotham.com", role: "SUPER_MANAGER" },
  %{username: "The patron 2", password: "PatronPassword", email: "patron2@gotham.com", role: "SUPER_MANAGER" },
  %{username: "The manager", password: "ManagerPassword", email: "manager@gotham.com", role: "MANAGER"},
  %{username: "The manager 2", password: "ManagerPassword", email: "manager2@gotham.com", role: "MANAGER"},
  %{username: "The employee", password: "EmployeePassword", email: "employee@gotham.com", role: "EMPLOYEE"},
  %{username: "The employee 2", password: "EmployeePassword", email: "employee2@gotham.com", role: "EMPLOYEE"},
  %{username: "User2", password: "password2", email: "user2@example.com", role: "EMPLOYEE"},
  %{username: "User3", password: "password3", email: "user3@example.com", role: "EMPLOYEE"},
  %{username: "User4", password: "password4", email: "user4@example.com", role: "EMPLOYEE"},
  %{username: "User5", password: "password5", email: "user5@example.com", role: "EMPLOYEE"},
  ]
  
# Insert users
Repo.transaction(fn ->
  Enum.each(users, fn user_params ->
    user = %User{}
    |> User.registration_changeset(user_params)
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
    |> Group.changeset(groups_params)
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
    clock = %Group_users{}
            |> Group_users.changeset(group_users_params)
            |> Repo.insert()
    case clock do
      {:ok, _} -> IO.puts("Users add in group successfully")
      {:error, changeset} -> IO.inspect(changeset.errors)
    end
  end)
end)

IO.puts("Employee add in group successfully")

group_managers = [
  %{group_id: 1, user_id: 3},
  %{group_id: 1, user_id: 4},
]

# Insert group_managers
Repo.transaction(fn ->
  Enum.each(group_managers, fn group_managers_params ->
    clock = %Group_managers{}
            |> Group_managers.changeset(group_managers_params)
            |> Repo.insert()
    case clock do
      {:ok, _} -> IO.puts("Users add in group successfully")
      {:error, changeset} -> IO.inspect(changeset.errors)
    end
  end)
end)

IO.puts("Manager add in group successfully")


clocks = [
  %{time: "2023-11-02 08:30:00", status: true, user_id: 1},
  %{time: "2023-11-02 09:00:00", status: true, user_id: 2},
  %{time: "2023-11-02 09:30:00", status: true, user_id: 3},
  %{time: "2023-11-02 09:00:00", status: true, user_id: 4},
  %{time: "2023-11-02 10:30:00", status: true, user_id: 5},
  %{time: "2023-11-02 09:00:00", status: true, user_id: 6},
  %{time: "2023-11-02 08:30:00", status: true, user_id: 7},
  %{time: "2023-11-02 12:00:00", status: true, user_id: 8},
  %{time: "2023-11-02 09:30:00", status: true, user_id: 9},
  %{time: "2023-11-02 08:00:00", status: true, user_id: 10}
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
  %{start_time: "2023-11-03T07:00:00Z", end_time: "2023-11-03T08:00:00Z", user_id: 1, is_pause: false},
  %{start_time: "2023-11-03T09:00:00Z", end_time: "2023-11-03T12:00:00Z", user_id: 1, is_pause: true},
  %{start_time: "2023-11-03T13:00:00Z", end_time: "2023-11-03T17:00:00Z", user_id: 1, is_pause: true},

  %{start_time: "2023-11-03T06:45:00Z", end_time: "2023-11-03T07:45:00Z", user_id: 2, is_pause: false},
  %{start_time: "2023-11-03T08:45:00Z", end_time: "2023-11-03T12:15:00Z", user_id: 2, is_pause: true},
  %{start_time: "2023-11-03T13:15:00Z", end_time: "2023-11-03T17:00:00Z", user_id: 2, is_pause: true},

  %{start_time: "2023-11-03T08:15:00Z", end_time: "2023-11-03T09:15:00Z", user_id: 3, is_pause: false},
  %{start_time: "2023-11-03T10:15:00Z", end_time: "2023-11-03T14:15:00Z", user_id: 3, is_pause: true},
  %{start_time: "2023-11-03T15:15:00Z", end_time: "2023-11-03T17:00:00Z", user_id: 3, is_pause: true},

  %{start_time: "2023-11-03T07:30:00Z", end_time: "2023-11-03T08:30:00Z", user_id: 4, is_pause: false},
  %{start_time: "2023-11-03T09:30:00Z", end_time: "2023-11-03T13:00:00Z", user_id: 4, is_pause: true},
  %{start_time: "2023-11-03T14:00:00Z", end_time: "2023-11-03T17:15:00Z", user_id: 4, is_pause: true},

  %{start_time: "2023-11-03T06:15:00Z", end_time: "2023-11-03T07:15:00Z", user_id: 5, is_pause: false},
  %{start_time: "2023-11-03T08:15:00Z", end_time: "2023-11-03T12:45:00Z", user_id: 5, is_pause: true},
  %{start_time: "2023-11-03T13:45:00Z", end_time: "2023-11-03T17:30:00Z", user_id: 5, is_pause: true},

  %{start_time: "2023-11-03T08:45:00Z", end_time: "2023-11-03T09:45:00Z", user_id: 6, is_pause: false},
  %{start_time: "2023-11-03T10:45:00Z", end_time: "2023-11-03T14:45:00Z", user_id: 6, is_pause: true},
  %{start_time: "2023-11-03T15:45:00Z", end_time: "2023-11-03T17:30:00Z", user_id: 6, is_pause: true},

  %{start_time: "2023-11-03T07:00:00Z", end_time: "2023-11-03T08:00:00Z", user_id: 7, is_pause: false},
  %{start_time: "2023-11-03T09:00:00Z", end_time: "2023-11-03T13:30:00Z", user_id: 7, is_pause: true},
  %{start_time: "2023-11-03T14:30:00Z", end_time: "2023-11-03T17:30:00Z", user_id: 7, is_pause: true},

  %{start_time: "2023-11-03T07:15:00Z", end_time: "2023-11-03T08:15:00Z", user_id: 8, is_pause: false},
  %{start_time: "2023-11-03T09:15:00Z", end_time: "2023-11-03T13:15:00Z", user_id: 8, is_pause: true},
  %{start_time: "2023-11-03T14:15:00Z", end_time: "2023-11-03T17:15:00Z", user_id: 8, is_pause: true},

  %{start_time: "2023-11-03T06:30:00Z", end_time: "2023-11-03T07:30:00Z", user_id: 9, is_pause: false},
  %{start_time: "2023-11-03T08:30:00Z", end_time: "2023-11-03T12:00:00Z", user_id: 9, is_pause: true},
  %{start_time: "2023-11-03T13:00:00Z", end_time: "2023-11-03T17:45:00Z", user_id: 9, is_pause: true},

  %{start_time: "2023-11-03T07:30:00Z", end_time: "2023-11-03T08:30:00Z", user_id: 10, is_pause: false},
  %{start_time: "2023-11-03T09:30:00Z", end_time: "2023-11-03T13:30:00Z", user_id: 10, is_pause: true},
  %{start_time: "2023-11-03T14:30:00Z", end_time: "2023-11-03T17:45:00Z", user_id: 10, is_pause: true},

  %{start_time: "2023-11-03T07:00:00Z", end_time: "2023-11-03T08:00:00Z", user_id: 1, is_pause: false},
  %{start_time: "2023-11-03T09:00:00Z", end_time: "2023-11-03T10:30:00Z", user_id: 1, is_pause: true},
  %{start_time: "2023-11-03T12:00:00Z", end_time: "2023-11-03T13:00:00Z", user_id: 1, is_pause: true},
  %{start_time: "2023-11-03T14:30:00Z", end_time: "2023-11-03T17:00:00Z", user_id: 1, is_pause: true},

  %{start_time: "2023-11-03T06:45:00Z", end_time: "2023-11-03T07:45:00Z", user_id: 2, is_pause: false},
  %{start_time: "2023-11-03T08:45:00Z", end_time: "2023-11-03T10:15:00Z", user_id: 2, is_pause: true},
  %{start_time: "2023-11-03T12:15:00Z", end_time: "2023-11-03T13:15:00Z", user_id: 2, is_pause: true},
  %{start_time: "2023-11-03T14:15:00Z", end_time: "2023-11-03T17:00:00Z", user_id: 2, is_pause: true},

  %{start_time: "2023-11-03T08:15:00Z", end_time: "2023-11-03T09:15:00Z", user_id: 3, is_pause: false},
  %{start_time: "2023-11-03T10:15:00Z", end_time: "2023-11-03T11:45:00Z", user_id: 3, is_pause: true},
  %{start_time: "2023-11-03T13:15:00Z", end_time: "2023-11-03T13:45:00Z", user_id: 3, is_pause: true},
  %{start_time: "2023-11-03T15:15:00Z", end_time: "2023-11-03T17:00:00Z", user_id: 3, is_pause: true},

  %{start_time: "2023-11-03T07:30:00Z", end_time: "2023-11-03T08:30:00Z", user_id: 4, is_pause: false},
  %{start_time: "2023-11-03T09:30:00Z", end_time: "2023-11-03T11:00:00Z", user_id: 4, is_pause: true},
  %{start_time: "2023-11-03T13:00:00Z", end_time: "2023-11-03T13:30:00Z", user_id: 4, is_pause: true},
  %{start_time: "2023-11-03T14:00:00Z", end_time: "2023-11-03T17:15:00Z", user_id: 4, is_pause: true},

  %{start_time: "2023-11-03T06:15:00Z", end_time: "2023-11-03T07:15:00Z", user_id: 5, is_pause: false},
  %{start_time: "2023-11-03T08:15:00Z", end_time: "2023-11-03T09:45:00Z", user_id: 5, is_pause: true},
  %{start_time: "2023-11-03T13:45:00Z", end_time: "2023-11-03T14:30:00Z", user_id: 5, is_pause: true},
  %{start_time: "2023-11-03T15:30:00Z", end_time: "2023-11-03T17:00:00Z", user_id: 5, is_pause: true},

  %{start_time: "2023-11-03T08:45:00Z", end_time: "2023-11-03T09:45:00Z", user_id: 6, is_pause: false},
  %{start_time: "2023-11-03T10:45:00Z", end_time: "2023-11-03T11:45:00Z", user_id: 6, is_pause: true},
  %{start_time: "2023-11-03T15:45:00Z", end_time: "2023-11-03T17:30:00Z", user_id: 6, is_pause: true},

  %{start_time: "2023-11-03T07:00:00Z", end_time: "2023-11-03T08:00:00Z", user_id: 7, is_pause: false},
  %{start_time: "2023-11-03T09:00:00Z", end_time: "2023-11-03T10:30:00Z", user_id: 7, is_pause: true},
  %{start_time: "2023-11-03T12:30:00Z", end_time: "2023-11-03T13:30:00Z", user_id: 7, is_pause: true},
  %{start_time: "2023-11-03T15:30:00Z", end_time: "2023-11-03T17:30:00Z", user_id: 7, is_pause: true},

  %{start_time: "2023-11-03T07:15:00Z", end_time: "2023-11-03T08:15:00Z", user_id: 8, is_pause: false},
  %{start_time: "2023-11-03T09:15:00Z", end_time: "2023-11-03T10:45:00Z", user_id: 8, is_pause: true},
  %{start_time: "2023-11-03T14:15:00Z", end_time: "2023-11-03T15:15:00Z", user_id: 8, is_pause: true},
  %{start_time: "2023-11-03T16:15:00Z", end_time: "2023-11-03T17:15:00Z", user_id: 8, is_pause: true},

  %{start_time: "2023-11-03T06:30:00Z", end_time: "2023-11-03T07:30:00Z", user_id: 9, is_pause: false},
  %{start_time: "2023-11-03T08:30:00Z", end_time: "2023-11-03T09:00:00Z", user_id: 9, is_pause: true},
  %{start_time: "2023-11-03T13:15:00Z", end_time: "2023-11-03T13:45:00Z", user_id: 9, is_pause: true},
  %{start_time: "2023-11-03T17:15:00Z", end_time: "2023-11-03T17:45:00Z", user_id: 9, is_pause: true},

  %{start_time: "2023-11-03T07:30:00Z", end_time: "2023-11-03T08:30:00Z", user_id: 10, is_pause: false},
  %{start_time: "2023-11-03T09:30:00Z", end_time: "2023-11-03T11:00:00Z", user_id: 10, is_pause: true},
  %{start_time: "2023-11-03T14:00:00Z", end_time: "2023-11-03T14:30:00Z", user_id: 10, is_pause: true},
  %{start_time: "2023-11-03T16:45:00Z", end_time: "2023-11-03T17:45:00Z", user_id: 10, is_pause: true}

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
