defmodule Gotham.UserControllerFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Gotham.UserController` context.
  """

  @doc """
  Generate a user.
  """
  def user_fixture(attrs \\ %{}) do
    {:ok, user} =
      attrs
      |> Enum.into(%{
        email: "some email",
        username: "some username"
      })
      |> Gotham.UserController.create_user()

    user
  end
end
