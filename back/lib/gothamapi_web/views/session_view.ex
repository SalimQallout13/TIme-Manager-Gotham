defmodule GothamapiWeb.SessionView do
  use GothamapiWeb, :view

  def render("token.json", %{access_token: access_token, role: role}) do
    %{
      access_token: access_token,
      role: role
    }
  end
end
