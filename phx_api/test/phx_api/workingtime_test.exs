defmodule TimeManager.WorkingtimeTest do
  use TimeManager.DataCase

  alias TimeManager.Workingtime

  describe "workingtimes" do
    alias TimeManager.Workingtime.Workingtimes

    import TimeManager.WorkingtimeFixtures

    @invalid_attrs %{end: nil, start: nil}

    test "list_workingtimes/0 returns all workingtimes" do
      workingtimes = workingtimes_fixture()
      assert Workingtime.list_workingtimes() == [workingtimes]
    end

    test "get_workingtimes!/1 returns the workingtimes with given id" do
      workingtimes = workingtimes_fixture()
      assert Workingtime.get_workingtimes!(workingtimes.id) == workingtimes
    end

    test "create_workingtimes/1 with valid data creates a workingtimes" do
      valid_attrs = %{end: ~U[2023-10-23 12:28:00Z], start: ~U[2023-10-23 12:28:00Z]}

      assert {:ok, %Workingtimes{} = workingtimes} = Workingtime.create_workingtimes(valid_attrs)
      assert workingtimes.end == ~U[2023-10-23 12:28:00Z]
      assert workingtimes.start == ~U[2023-10-23 12:28:00Z]
    end

    test "create_workingtimes/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Workingtime.create_workingtimes(@invalid_attrs)
    end

    test "update_workingtimes/2 with valid data updates the workingtimes" do
      workingtimes = workingtimes_fixture()
      update_attrs = %{end: ~U[2023-10-24 12:28:00Z], start: ~U[2023-10-24 12:28:00Z]}

      assert {:ok, %Workingtimes{} = workingtimes} = Workingtime.update_workingtimes(workingtimes, update_attrs)
      assert workingtimes.end == ~U[2023-10-24 12:28:00Z]
      assert workingtimes.start == ~U[2023-10-24 12:28:00Z]
    end

    test "update_workingtimes/2 with invalid data returns error changeset" do
      workingtimes = workingtimes_fixture()
      assert {:error, %Ecto.Changeset{}} = Workingtime.update_workingtimes(workingtimes, @invalid_attrs)
      assert workingtimes == Workingtime.get_workingtimes!(workingtimes.id)
    end

    test "delete_workingtimes/1 deletes the workingtimes" do
      workingtimes = workingtimes_fixture()
      assert {:ok, %Workingtimes{}} = Workingtime.delete_workingtimes(workingtimes)
      assert_raise Ecto.NoResultsError, fn -> Workingtime.get_workingtimes!(workingtimes.id) end
    end

    test "change_workingtimes/1 returns a workingtimes changeset" do
      workingtimes = workingtimes_fixture()
      assert %Ecto.Changeset{} = Workingtime.change_workingtimes(workingtimes)
    end
  end
end
