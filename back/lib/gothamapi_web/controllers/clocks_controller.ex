defmodule GothamapiWeb.ClocksController do
  use GothamapiWeb, :controller

  alias Gothamapi.Crud
  alias Gothamapi.Crud.Clocks

  action_fallback GothamapiWeb.FallbackController

  def index(conn, _params) do
    clocks = Crud.list_clocks()
    render(conn, "index.json", clocks: clocks)
  end

  def indexBy(conn, params) do
    if params["userID"] != nil do
      clocks = Crud.list_clocksByUserId(params["userID"])
      render(conn, "index.json", clocks: clocks)
    else
      if params["username"] != nil do
        clocks = Crud.list_clocksByUsername(params["username"])
        render(conn, "index.json", clocks: clocks)
      end
    end
  end

  def create(conn, %{"userID" => id, "time" => time}) do
    with {:ok, %Clocks{} = clocks} <- Crud.create_clocks(%{"user_id" => id, "time" => time}) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", Routes.clocks_path(conn, :show, clocks))
      |> render("show.json", clocks: clocks)
    end
  end

  def show(conn, %{"id" => id}) do
    clocks = Crud.get_clocks!(id)
    render(conn, "show.json", clocks: clocks)
  end

  def update(conn, %{"id" => id, "clocks" => clocks_params}) do
    clocks = Crud.get_clocks!(id)

    with {:ok, %Clocks{} = clocks} <- Crud.update_clocks(clocks, clocks_params) do
      render(conn, "show.json", clocks: clocks)
    end
  end

  def delete(conn, %{"id" => id}) do
    clocks = Crud.get_clocks!(id)

    with {:ok, %Clocks{}} <- Crud.delete_clocks(clocks) do
      send_resp(conn, :no_content, "")
    end
  end
end
