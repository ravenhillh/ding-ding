defmodule DingDingWeb.GoalLive.Show do
  use DingDingWeb, :live_view

  alias DingDing.Goals

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(%{"id" => id}, _url, socket) do
    goal = Goals.get_goal_with_steps!(id)
    {:noreply, assign(socket, goal: goal)}
  end

  @impl true
  def handle_event("toggle_step", %{"id" => id}, socket) do
    step = Goals.get_step!(id)
    {:ok, updated_step} = Goals.update_step(step, %{completed: !step.completed})

    goal = Goals.get_goal_with_steps!(step.goal_id)
    all_completed = Enum.all?(goal.steps, & &1.completed)

    if updated_step.completed or all_completed do
      send(self(), :play_ding)
    end

    {:noreply, assign(socket, goal: goal)}
  end

  @impl true
 def handle_info(:play_ding, socket) do
  IO.puts("🔔 Playing ding sound!")
  {:noreply, push_event(socket, "play-ding", %{})}
end

end
