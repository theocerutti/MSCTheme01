defmodule GothamWeb.UserController do
  use GothamWeb, :controller

  alias Gotham.UserController
  alias Gotham.UserController.User

  action_fallback GothamWeb.FallbackController

  def index(conn, params) do
    if Map.has_key?(params, "email") and Map.has_key?(params, "username") do
      user = UserController.get_user_from!(params["username"], params["email"])
      render(conn, "show.json", user: user)
    else
      users = UserController.list_users()
      render(conn, "index.json", users: users)
    end
  end

  def create(conn, %{"user" => user_params}) do
    with {:ok, %User{} = user} <- UserController.create_user(user_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", Routes.user_path(conn, :show, user))
      |> render("show.json", user: user)
    end
  end

  def show(conn, %{"id" => id}) do
    user = UserController.get_user!(id)
    render(conn, "show.json", user: user)
  end

  def update(conn, %{"id" => id, "user" => user_params}) do
    user = UserController.get_user!(id)

    with {:ok, %User{} = user} <- UserController.update_user(user, user_params) do
      render(conn, "show.json", user: user)
    end
  end

  def delete(conn, %{"id" => id}) do
    user = UserController.get_user!(id)

    with {:ok, %User{}} <- UserController.delete_user(user) do
      send_resp(conn, :no_content, "")
    end
  end
end
