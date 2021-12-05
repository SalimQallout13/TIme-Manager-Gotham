defmodule GothamapiWeb.WorkingtimesController do
  use GothamapiWeb, :controller

  alias Gothamapi.Crud
  alias Gothamapi.Crud.Workingtimes

  action_fallback GothamapiWeb.FallbackController

  def index(conn, _params) do
    worktimes = Crud.list_worktimes()
    render(conn, "index.json", worktimes: worktimes)
  end

  def indexBy(conn, params) do
    if params["start"] != nil and params["end"] != nil do
      worktimes = Crud.list_worktimesByUser(params["userID"], params["start"], params["end"])
      render(conn, "index.json", worktimes: worktimes)
    else
      if params["userID"] != nil do
        worktimes = Crud.list_worktimesByUserID(params["userID"])
        render(conn, "index.json", worktimes: worktimes)
      else
        if params["username"] != nil do
          worktimes = Crud.list_worktimesByUsername(params["username"])
          render(conn, "index.json", worktimes: worktimes)
        end
      end
    end
  end


  def create(conn, params) do
    with {:ok, %Workingtimes{} = workingtimes} <- Crud.create_workingtimes(
      %{user_id: params["userID"], start: params["start"], end: params["end"]}
    ) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", Routes.workingtimes_path(conn, :show, workingtimes))
      |> render("show.json", workingtimes: workingtimes)
    end
  end

  def show(conn, %{"id" => id}) do
    workingtimes = Crud.get_workingtimes!(id)
    render(conn, "show.json", workingtimes: workingtimes)
  end

  def update(conn, params) do
    workingtimes = Crud.get_workingtimes!(params["id"])
    with {:ok, %Workingtimes{} = workingtimes} <- Crud.update_workingtimes(workingtimes, %{start: params["start"], end: params["end"]}) do
      conn
      |> render("show.json", workingtimes: workingtimes)
    end
  end

  def delete(conn, %{"id" => id}) do
    workingtimes = Crud.get_workingtimes!(id)
    with {:ok, %Workingtimes{}} <- Crud.delete_workingtimes(workingtimes) do
      send_resp(conn, :no_content, "")
    end
  end
end
