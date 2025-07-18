defmodule DingDingWeb.GoalLive.Index do
  use DingDingWeb, :live_view

  alias DingDing.Goals
  alias DingDing.Goals.Goal

  @impl true
  def mount(_params, _session, socket) do
    {:ok, stream(socket, :goals, Goals.list_goals())}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Goal")
    |> assign(:goal, Goals.get_goal!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Goal")
    |> assign(:goal, %Goal{steps: []}) # Ensure steps is an empty list for new goals
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Goals")
    |> assign(:goal, nil)
  end

  @impl true
  def handle_info({DingDingWeb.GoalLive.FormComponent, {:saved, goal}}, socket) do
    {:noreply, stream_insert(socket, :goals, goal)}
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    goal = Goals.get_goal!(id)
    {:ok, _} = Goals.delete_goal(goal)

    {:noreply, stream_delete(socket, :goals, goal)}
  end
end
