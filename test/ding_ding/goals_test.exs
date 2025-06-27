defmodule DingDing.GoalsTest do
  use DingDing.DataCase

  alias DingDing.Goals

  describe "goals" do
    alias DingDing.Goals.Goal

    import DingDing.GoalsFixtures

    @invalid_attrs %{description: nil, title: nil, due_date: nil}

    test "list_goals/0 returns all goals" do
      goal = goal_fixture()
      assert Goals.list_goals() == [goal]
    end

    test "get_goal!/1 returns the goal with given id" do
      goal = goal_fixture()
      assert Goals.get_goal!(goal.id) == goal
    end

    test "create_goal/1 with valid data creates a goal" do
      valid_attrs = %{description: "some description", title: "some title", due_date: ~D[2025-06-22]}

      assert {:ok, %Goal{} = goal} = Goals.create_goal(valid_attrs)
      assert goal.description == "some description"
      assert goal.title == "some title"
      assert goal.due_date == ~D[2025-06-22]
    end

    test "create_goal/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Goals.create_goal(@invalid_attrs)
    end

    test "update_goal/2 with valid data updates the goal" do
      goal = goal_fixture()
      update_attrs = %{description: "some updated description", title: "some updated title", due_date: ~D[2025-06-23]}

      assert {:ok, %Goal{} = goal} = Goals.update_goal(goal, update_attrs)
      assert goal.description == "some updated description"
      assert goal.title == "some updated title"
      assert goal.due_date == ~D[2025-06-23]
    end

    test "update_goal/2 with invalid data returns error changeset" do
      goal = goal_fixture()
      assert {:error, %Ecto.Changeset{}} = Goals.update_goal(goal, @invalid_attrs)
      assert goal == Goals.get_goal!(goal.id)
    end

    test "delete_goal/1 deletes the goal" do
      goal = goal_fixture()
      assert {:ok, %Goal{}} = Goals.delete_goal(goal)
      assert_raise Ecto.NoResultsError, fn -> Goals.get_goal!(goal.id) end
    end

    test "change_goal/1 returns a goal changeset" do
      goal = goal_fixture()
      assert %Ecto.Changeset{} = Goals.change_goal(goal)
    end
  end
end
