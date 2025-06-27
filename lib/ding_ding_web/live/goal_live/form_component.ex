defmodule DingDingWeb.GoalLive.FormComponent do
  use DingDingWeb, :live_component

  alias DingDing.Goals
  alias DingDing.Goals.Step

  @impl true
  def render(assigns) do
    ~H"""
    <div>
      <.header>
        {@title}
        <:subtitle>Use this form to manage goal records in your database.</:subtitle>
      </.header>

      <.simple_form
        for={@form}
        id="goal-form"
        phx-target={@myself}
        phx-change="validate"
        phx-submit="save"
      >
        <.input field={@form[:title]} type="text" label="Title" />
        <.input field={@form[:description]} type="text" label="Description" />
        <.input field={@form[:due_date]} type="date" label="Due date" />

        <div class="space-y-4">
          <div class="flex items-center justify-between">
            <h4 class="text-lg font-medium">Steps</h4>
            <.button
              type="button"
              phx-click="add_step"
              phx-target={@myself}
              class="bg-green-600 hover:bg-green-700"
            >
              Add Step
            </.button>
          </div>

          <.inputs_for :let={step_f} field={@form[:steps]}>
            <div class="flex items-center gap-2 p-3 border border-gray-200 rounded-lg">
              <div class="flex-1">
                <.input field={step_f[:title]} type="text" label="Step" />
              </div>
              <.button
                type="button"
                phx-click="remove_step"
                phx-value-index={step_f.index}
                phx-target={@myself}
                class="bg-red-600 hover:bg-red-700 text-white px-3 py-2 rounded text-sm"
              >
                Remove
              </.button>
            </div>
          </.inputs_for>
        </div>

        <:actions>
          <.button phx-disable-with="Saving...">Save Goal</.button>
        </:actions>
      </.simple_form>
    </div>
    """
  end

  @impl true
  def update(%{goal: goal} = assigns, socket) do
    changeset = Goals.change_goal(goal)

    # Add at least one empty step if new goal and no steps yet
    changeset =
      if goal.id == nil and empty_steps?(goal.steps) do
        Ecto.Changeset.put_assoc(changeset, :steps, [%Step{}])
      else
        changeset
      end

    {:ok,
     socket
     |> assign(assigns)
     |> assign(:form, to_form(changeset))}
  end

  # Helper function to safely check if steps are empty
  defp empty_steps?(%Ecto.Association.NotLoaded{}), do: true
  defp empty_steps?(steps) when is_list(steps), do: Enum.empty?(steps)
  defp empty_steps?(nil), do: true

  @impl true
  def handle_event("validate", %{"goal" => goal_params}, socket) do
    changeset = Goals.change_goal(socket.assigns.goal, goal_params)
    {:noreply, assign(socket, :form, to_form(changeset, action: :validate))}
  end

  def handle_event("add_step", _params, socket) do
    existing_steps = get_current_steps(socket.assigns.form.source)
    new_steps = existing_steps ++ [%Step{}]

    changeset =
      socket.assigns.goal
      |> Goals.change_goal()
      |> Ecto.Changeset.put_assoc(:steps, new_steps)

    {:noreply, assign(socket, :form, to_form(changeset))}
  end

  def handle_event("remove_step", %{"index" => index_str}, socket) do
    index = String.to_integer(index_str)
    existing_steps = get_current_steps(socket.assigns.form.source)

    # Don't allow removing the last step
    if length(existing_steps) > 1 do
      new_steps = List.delete_at(existing_steps, index)

      changeset =
        socket.assigns.goal
        |> Goals.change_goal()
        |> Ecto.Changeset.put_assoc(:steps, new_steps)

      {:noreply, assign(socket, :form, to_form(changeset))}
    else
      {:noreply, socket}
    end
  end

  def handle_event("save", %{"goal" => goal_params}, socket) do
    save_goal(socket, socket.assigns.action, goal_params)
  end

  defp get_current_steps(changeset) do
    case Ecto.Changeset.get_assoc(changeset, :steps) do
      steps when is_list(steps) -> steps
      _ -> [%Step{}]
    end
  end

  defp save_goal(socket, :edit, goal_params) do
    case Goals.update_goal(socket.assigns.goal, goal_params) do
      {:ok, goal} ->
        notify_parent({:saved, goal})

        {:noreply,
         socket
         |> put_flash(:info, "Goal updated successfully")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, :form, to_form(changeset))}
    end
  end

  defp save_goal(socket, :new, goal_params) do
    case Goals.create_goal(goal_params) do
      {:ok, goal} ->
        notify_parent({:saved, goal})

        {:noreply,
         socket
         |> put_flash(:info, "Goal created successfully")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, :form, to_form(changeset))}
    end
  end

  defp notify_parent(msg), do: send(self(), {__MODULE__, msg})
end
