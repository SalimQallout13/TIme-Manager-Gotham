defmodule GothamapiWeb.UsersController do
  use GothamapiWeb, :controller

  alias Gothamapi.Crud
  alias Gothamapi.Crud.Users

  action_fallback GothamapiWeb.FallbackController

  def index(conn, _params) do
    users = Crud.list_users()
    render(conn, "index.json", users: users)
  end

  def indexBy(conn, params) do
    if params["email"] != nil do
      with {:ok, users} <- Crud.get_user_by_email(params["email"]) do
        render(conn, "show.json", users: users)
      end
    else
      if params["username"] != nil do
        with {:ok, users} <- Crud.get_user_by_username(params["username"]) do
          render(conn, "index.json", users: users)
        end
      end
    end
  end


  def create(conn, params) do
    case Crud.get_user_by_email(params["email"]) do
      {:ok, users} -> text(conn, "Un utilisateur avec le meme mail existe déja")
      {:error, :not_found} -> with {:ok, %Users{} = users} <- Crud.create_users(
        %{username: params["username"], email: params["email"], password: params["password"],role: params["role"]}) do
           conn
           |> put_status(:created)
           |> render("show.json", users: users)
           end
    end
  end



  def show(conn, %{"userID" => id}) do
    users = Crud.get_users!(id)
    render(conn, "show.json", users: users)
  end

  def update(conn, params) do
    users = Crud.get_users!(params["userID"])
    with {:ok, %Users{} = users} <- Crud.update_users(
      users,
      %{username: params["username"], email: params["email"]}
    ) do
      render(conn, "show.json", users: users)
    end
  end

  def delete(conn, %{"userID" => id}) do
    users = Crud.get_users!(id)

    with {:ok, %Users{}} <- Crud.delete_users(users) do
      conn
      |>put_status(202)
      |>text("Supression utilisateur reussi")
    end
  end
end
