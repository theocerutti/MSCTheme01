defmodule Gotham.UserControllerTest do
  use Gotham.DataCase

  alias Gotham.UserController

  describe "users" do
    alias Gotham.UserController.User

    import Gotham.UserControllerFixtures

    @invalid_attrs %{email: nil, username: nil}

    test "list_users/0 returns all users" do
      user = user_fixture()
      assert UserController.list_users() == [user]
    end

    test "get_user!/1 returns the user with given id" do
      user = user_fixture()
      assert UserController.get_user!(user.id) == user
    end

    test "create_user/1 with valid data creates a user" do
      valid_attrs = %{email: "some email", username: "some username"}

      assert {:ok, %User{} = user} = UserController.create_user(valid_attrs)
      assert user.email == "some email"
      assert user.username == "some username"
    end

    test "create_user/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = UserController.create_user(@invalid_attrs)
    end

    test "update_user/2 with valid data updates the user" do
      user = user_fixture()
      update_attrs = %{email: "some updated email", username: "some updated username"}

      assert {:ok, %User{} = user} = UserController.update_user(user, update_attrs)
      assert user.email == "some updated email"
      assert user.username == "some updated username"
    end

    test "update_user/2 with invalid data returns error changeset" do
      user = user_fixture()
      assert {:error, %Ecto.Changeset{}} = UserController.update_user(user, @invalid_attrs)
      assert user == UserController.get_user!(user.id)
    end

    test "delete_user/1 deletes the user" do
      user = user_fixture()
      assert {:ok, %User{}} = UserController.delete_user(user)
      assert_raise Ecto.NoResultsError, fn -> UserController.get_user!(user.id) end
    end

    test "change_user/1 returns a user changeset" do
      user = user_fixture()
      assert %Ecto.Changeset{} = UserController.change_user(user)
    end
  end
end
