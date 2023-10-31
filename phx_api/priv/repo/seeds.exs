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
alias TimeManager.Clocks.Clock
alias TimeManager.Workingtime.Workingtimes



users = [
  %{username: "John Doe", password: "azerty", email: "john@example.com", },
  %{username: "Jane Smith", password: "JaneSmithPass", email: "jane@example.com"},
]

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

clocks = [
  %{time: "2000-01-01 23:00:07", status: true, user_id: 1},
  %{time: "2020-01-01 14:00:07", status: true, user_id: 2},
]
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

IO.puts("Seeds Clocks inserted successfully")

workingTimes = [
  %{start: "2000-01-01T08:00:07Z", end_time: "2000-01-01T17:00:07Z", user_id: 1},
  %{start: "2000-06-01T09:00:07Z", end_time: "2000-06-01T18:00:07Z", user_id: 1},
  %{start: "2000-01-01T08:00:07Z", end_time: "2000-01-01T17:00:07Z", user_id: 2},
  %{start: "2000-06-02T09:00:07Z", end_time: "2000-06-02T18:00:07Z", user_id: 2},
  %{start: "2000-06-03T08:00:07Z", end_time: "2000-06-03T12:00:07Z", user_id: 2},
  %{start: "2000-06-03T15:00:07Z", end_time: "2000-06-03T18:00:07Z", user_id: 2}
]

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

IO.puts("Seeds WorkingTimes inserted successfully")
