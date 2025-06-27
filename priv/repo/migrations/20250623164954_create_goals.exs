defmodule DingDing.Repo.Migrations.CreateGoals do
  use Ecto.Migration

  def change do
    create table(:goals) do
      add :title, :string
      add :description, :text
      add :due_date, :date

      timestamps(type: :utc_datetime)
    end
  end
end
