defmodule Gotham.Repo.Migrations.CreateUsers do
  use Ecto.Migration

  def change do
    create table(:users) do
      add :username, :string, null: false, unique: true
      add :email, :string, null: false, unique: true

      timestamps()
    end

    create unique_index(:users, [:email], name: :email_index)
    create unique_index(:users, [:username], name: :username_index)

  end
end
