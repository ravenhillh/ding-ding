defmodule DingDing.Goals.Goal do
  use Ecto.Schema
  import Ecto.Changeset

  schema "goals" do
    field :title, :string
    field :description, :string
    field :due_date, :date

    has_many :steps, DingDing.Goals.Step, on_replace: :delete

    timestamps()
  end

  def changeset(goal, attrs) do
    goal
    |> cast(attrs, [:title, :description, :due_date])
    |> validate_required([:title])
    |> cast_assoc(:steps, with: &DingDing.Goals.Step.changeset/2)
  end
end
