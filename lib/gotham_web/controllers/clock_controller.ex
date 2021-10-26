defmodule GothamWeb.ClockController do
  use GothamWeb, :controller

  alias Gotham.ClockController
  alias Gotham.ClockController.Clock
  alias Gotham.UserController
  alias Gotham.Repo

  action_fallback GothamWeb.FallbackController

  def index(conn, _params) do
    clocks = ClockController.list_clocks()
    render(conn, "index.json", clocks: clocks)
  end

  def create(conn, %{"clock" => clock_params}) do
    with {:ok, %Clock{} = clock} <- ClockController.create_clock(clock_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", Routes.clock_path(conn, :show, clock))
      |> render("show.json", clock: clock)
    end
  end

  def show(conn, %{"id" => id}) do
    clock = ClockController.get_clock!(id)
    render(conn, "show.json", clock: clock)
  end

  def update(conn, %{"id" => id, "clock" => clock_params}) do
    clock = ClockController.get_clock!(id)

    with {:ok, %Clock{} = clock} <- ClockController.update_clock(clock, clock_params) do
      render(conn, "show.json", clock: clock)
    end
  end

  def delete(conn, %{"id" => id}) do
    clock = ClockController.get_clock!(id)

    with {:ok, %Clock{}} <- ClockController.delete_clock(clock) do
      send_resp(conn, :no_content, "")
    end
  end

  def user_clock(conn, %{"userID" => user_id}) do
    user = UserController.get_user!(user_id)
    |> Repo.preload(:clock)
    IO.inspect user
    # if clock is nil create it
    if user.clock == nil do
      ClockController.create_clock(%{
        status: true,
        time: DateTime.utc_now(),
        user_id: user_id
      })
    end
    user = Repo.preload(user, :clock)
    IO.inspect user
    render(conn, "index.json", clocks: [])
  end

  def get_user_clock(conn, %{"userID" => user_id}) do
    user = UserController.get_user!(user_id)
    |> Repo.preload(:clock)
    render(conn, "show.json", clock: user.clock)
  end
end
