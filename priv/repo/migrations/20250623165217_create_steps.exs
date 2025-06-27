defmodule DingDing.Repo.Migrations.CreateSteps do
  use Ecto.Migration

  def change do
    create table(:steps) do
      add :title, :string
      add :completed, :boolean, default: false, null: false
      add :goal_id, references(:goals, on_delete: :nothing)

      timestamps(type: :utc_datetime)
    end

    create index(:steps, [:goal_id])
  end
end
