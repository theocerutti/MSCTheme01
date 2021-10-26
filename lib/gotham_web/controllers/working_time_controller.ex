defmodule GothamWeb.WorkingTimeController do
  use GothamWeb, :controller

  alias Gotham.WorkingTimeController
  alias Gotham.WorkingTimeController.WorkingTime
  alias Gotham.UserController
  alias Gotham.Repo

  action_fallback GothamWeb.FallbackController

  def create(conn, %{"working_time" => working_time_params}) do
    # Create in user
    with {:ok, %WorkingTime{} = working_time} <- WorkingTimeController.create_working_time(working_time_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", Routes.working_time_path(conn, :show, working_time))
      |> render("show.json", working_time: working_time)
    end
  end

  def show(conn, %{"id" => id}) do
    working_time = WorkingTimeController.get_working_time!(id)
    render(conn, "show.json", working_time: working_time)
  end

  def update(conn, %{"id" => id, "working_time" => working_time_params}) do
    working_time = WorkingTimeController.get_working_time!(id)

    with {:ok, %WorkingTime{} = working_time} <- WorkingTimeController.update_working_time(working_time, working_time_params) do
      render(conn, "show.json", working_time: working_time)
    end
  end

  def delete(conn, %{"id" => id}) do
    working_time = WorkingTimeController.get_working_time!(id)

    with {:ok, %WorkingTime{}} <- WorkingTimeController.delete_working_time(working_time) do
      send_resp(conn, :no_content, "")
    end
  end

  def user_working_times(conn, params) do
    user = UserController.get_user!(params["userID"])
    |> Repo.preload([:working_times])
    working_times = user.working_times
    # filtermm<|
    if Map.has_key?(params, "start") and Map.has_key?(params, "end") do
      { :ok, start_param_time, 0 } = DateTime.from_iso8601(params["start"])
      { :ok, end_param_time, 0 } = DateTime.from_iso8601(params["end"])
      working_times = Enum.filter(working_times, fn (working_time) -> working_time.start >= start_param_time and working_time.end <= end_param_time end)
      render(conn, "index.json", workingtimes: working_times)
    else
      render(conn, "index.json", workingtimes: working_times)
    end
  end
end
