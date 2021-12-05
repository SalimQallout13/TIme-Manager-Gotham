defmodule GothamapiWeb.SessionController do
  use GothamapiWeb, :controller

  alias Gothamapi.Crud
  alias Gothamapi.Guardian

  action_fallback GothamapiWeb.FallbackController

  def new(conn, %{"email" => email, "password" => password}) do
    case Crud.authenticate_user(email, password) do
      {:ok, users} ->
        {:ok, access_token, _claims} =
          Guardian.encode_and_sign(users, %{}, token_type: "access", ttl: {10, :minute})
        {:ok, refresh_token, _claims} =
          Guardian.encode_and_sign(users, %{}, token_type: "refresh", ttl: {7, :day})
        conn
        |> put_resp_cookie("ruid", refresh_token)
        |> put_status(:created)
        |> render("token.json", access_token: access_token, role: users.role)
      {:error, :unauthorized} ->
        body = Jason.encode!(%{error: "unauthorized"})
        conn
        |> send_resp(401, body)
      {:error, :not_found} ->
        conn
        |> send_resp(404, 'Identification incorrect')
    end
  end

  def refresh(conn, _params) do
    refresh_token =
      Plug.Conn.fetch_cookies(conn)
      |> Map.from_struct()
      |> get_in([:cookies, "ruid"])

    case Guardian.exchange(refresh_token, "refresh", "access", ttl: {1, :minute})do
      {:ok, _old_stuff, {new_access_token, _new_claims}} ->
        conn
        |> put_status(:created)
        |> render("token.json", %{access_token: new_access_token})

      {:error, _reason} ->
        body = Jason.encode!(%{error: "unauthorized"})
        conn
        |> send_resp(401, body)
    end
  end

  def delete(conn, _params)do
    token = Guardian.Plug.current_token(conn)
    case Guardian.revoke(token) do
      {:ok, _claims} ->
        conn
        |> delete_resp_cookie("ruid")
        |> put_status(202)
        |> text("Deconnexion reussi")
    end

  end



end
