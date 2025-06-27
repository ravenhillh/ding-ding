defmodule DingDing.Goals.Step do
  use Ecto.Schema
  import Ecto.Changeset

  schema "steps" do
    field :title, :string
    field :completed, :boolean, default: false

    belongs_to :goal, DingDing.Goals.Goal

    timestamps()
  end

  def changeset(step, attrs) do
    step
    |> cast(attrs, [:title, :completed])
    |> validate_required([:title])
  end
end
