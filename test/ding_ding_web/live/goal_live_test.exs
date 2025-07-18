defmodule DingDingWeb.GoalLiveTest do
  use DingDingWeb.ConnCase

  import Phoenix.LiveViewTest
  import DingDing.GoalsFixtures

  @create_attrs %{description: "some description", title: "some title", due_date: "2025-06-22"}
  @update_attrs %{description: "some updated description", title: "some updated title", due_date: "2025-06-23"}
  @invalid_attrs %{description: nil, title: nil, due_date: nil}

  defp create_goal(_) do
    goal = goal_fixture()
    %{goal: goal}
  end

  describe "Index" do
    setup [:create_goal]

    test "lists all goals", %{conn: conn, goal: goal} do
      {:ok, _index_live, html} = live(conn, ~p"/goals")

      assert html =~ "Listing Goals"
      assert html =~ goal.description
    end

    test "saves new goal", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, ~p"/goals")

      assert index_live |> element("a", "New Goal") |> render_click() =~
               "New Goal"

      assert_patch(index_live, ~p"/goals/new")

      assert index_live
             |> form("#goal-form", goal: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert index_live
             |> form("#goal-form", goal: @create_attrs)
             |> render_submit()

      assert_patch(index_live, ~p"/goals")

      html = render(index_live)
      assert html =~ "Goal created successfully"
      assert html =~ "some description"
    end

    test "updates goal in listing", %{conn: conn, goal: goal} do
      {:ok, index_live, _html} = live(conn, ~p"/goals")

      assert index_live |> element("#goals-#{goal.id} a", "Edit") |> render_click() =~
               "Edit Goal"

      assert_patch(index_live, ~p"/goals/#{goal}/edit")

      assert index_live
             |> form("#goal-form", goal: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert index_live
             |> form("#goal-form", goal: @update_attrs)
             |> render_submit()

      assert_patch(index_live, ~p"/goals")

      html = render(index_live)
      assert html =~ "Goal updated successfully"
      assert html =~ "some updated description"
    end

    test "deletes goal in listing", %{conn: conn, goal: goal} do
      {:ok, index_live, _html} = live(conn, ~p"/goals")

      assert index_live |> element("#goals-#{goal.id} a", "Delete") |> render_click()
      refute has_element?(index_live, "#goals-#{goal.id}")
    end
  end

  describe "Show" do
    setup [:create_goal]

    test "displays goal", %{conn: conn, goal: goal} do
      {:ok, _show_live, html} = live(conn, ~p"/goals/#{goal}")

      assert html =~ "Show Goal"
      assert html =~ goal.description
    end

    test "updates goal within modal", %{conn: conn, goal: goal} do
      {:ok, show_live, _html} = live(conn, ~p"/goals/#{goal}")

      assert show_live |> element("a", "Edit") |> render_click() =~
               "Edit Goal"

      assert_patch(show_live, ~p"/goals/#{goal}/show/edit")

      assert show_live
             |> form("#goal-form", goal: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert show_live
             |> form("#goal-form", goal: @update_attrs)
             |> render_submit()

      assert_patch(show_live, ~p"/goals/#{goal}")

      html = render(show_live)
      assert html =~ "Goal updated successfully"
      assert html =~ "some updated description"
    end
  end
end
