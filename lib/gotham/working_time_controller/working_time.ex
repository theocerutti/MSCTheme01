defmodule Gotham.WorkingTimeController.WorkingTime do
  use Ecto.Schema
  import Ecto.Changeset
  import EctoCommons.DateTimeValidator

  schema "workingtimes" do
    field :end, :utc_datetime
    field :start, :utc_datetime
    belongs_to :user, Gotham.UserController.User

    timestamps()
  end

  @doc false
  def changeset(working_time, attrs) do
    working_time
    |> cast(attrs, [:start, :end, :user_id])
    |> validate_datetime(:start)
    |> validate_datetime(:end)
    |> validate_required([:start, :end, :user_id])
    |> assoc_constraint(:user)
  end
end
