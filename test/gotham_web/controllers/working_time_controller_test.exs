defmodule GothamWeb.WorkingTimeControllerTest do
  use GothamWeb.ConnCase

  import Gotham.WorkingTimeControllerFixtures

  alias Gotham.WorkingTimeController.WorkingTime

  @create_attrs %{
    end: ~N[2021-10-24 19:07:00],
    start: ~N[2021-10-24 19:07:00]
  }
  @update_attrs %{
    end: ~N[2021-10-25 19:07:00],
    start: ~N[2021-10-25 19:07:00]
  }
  @invalid_attrs %{end: nil, start: nil}

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all workingtimes", %{conn: conn} do
      conn = get(conn, Routes.working_time_path(conn, :index))
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create working_time" do
    test "renders working_time when data is valid", %{conn: conn} do
      conn = post(conn, Routes.working_time_path(conn, :create), working_time: @create_attrs)
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get(conn, Routes.working_time_path(conn, :show, id))

      assert %{
               "id" => ^id,
               "end" => "2021-10-24T19:07:00",
               "start" => "2021-10-24T19:07:00"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.working_time_path(conn, :create), working_time: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update working_time" do
    setup [:create_working_time]

    test "renders working_time when data is valid", %{conn: conn, working_time: %WorkingTime{id: id} = working_time} do
      conn = put(conn, Routes.working_time_path(conn, :update, working_time), working_time: @update_attrs)
      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get(conn, Routes.working_time_path(conn, :show, id))

      assert %{
               "id" => ^id,
               "end" => "2021-10-25T19:07:00",
               "start" => "2021-10-25T19:07:00"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn, working_time: working_time} do
      conn = put(conn, Routes.working_time_path(conn, :update, working_time), working_time: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete working_time" do
    setup [:create_working_time]

    test "deletes chosen working_time", %{conn: conn, working_time: working_time} do
      conn = delete(conn, Routes.working_time_path(conn, :delete, working_time))
      assert response(conn, 204)

      assert_error_sent 404, fn ->
        get(conn, Routes.working_time_path(conn, :show, working_time))
      end
    end
  end

  defp create_working_time(_) do
    working_time = working_time_fixture()
    %{working_time: working_time}
  end
end
