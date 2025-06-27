defmodule DingDing.GoalsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `DingDing.Goals` context.
  """

  @doc """
  Generate a goal.
  """
  def goal_fixture(attrs \\ %{}) do
    {:ok, goal} =
      attrs
      |> Enum.into(%{
        description: "some description",
        due_date: ~D[2025-06-22],
        title: "some title"
      })
      |> DingDing.Goals.create_goal()

    goal
  end
end
