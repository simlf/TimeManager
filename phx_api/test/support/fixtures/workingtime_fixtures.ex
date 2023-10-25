defmodule TimeManager.WorkingtimeFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `TimeManager.Workingtime` context.
  """

  @doc """
  Generate a workingtimes.
  """
  def workingtimes_fixture(attrs \\ %{}) do
    {:ok, workingtimes} =
      attrs
      |> Enum.into(%{
        end: ~U[2023-10-23 12:28:00Z],
        start: ~U[2023-10-23 12:28:00Z]
      })
      |> TimeManager.Workingtime.create_workingtimes()

    workingtimes
  end
end
