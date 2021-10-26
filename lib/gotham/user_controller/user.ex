defmodule Gotham.UserController.User do
  use Ecto.Schema
  import Ecto.Changeset
  import EctoCommons.EmailValidator

  schema "users" do
    field :email, :string
    field :username, :string
    has_one :clock, Gotham.ClockController.Clock
    has_many :working_times, Gotham.WorkingTimeController.WorkingTime

    timestamps()
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:username, :email])
    |> validate_email(:email)
    |> validate_required([:username, :email])
    |> unique_constraint(:email, name: :email_index)
    |> unique_constraint(:username, name: :username_index)
  end
end
