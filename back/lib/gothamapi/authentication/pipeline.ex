defmodule Gothamapi.Guardian.AuthPipeline do
  @claims %{typ: "access"}

  use Guardian.Plug.Pipeline,
      otp_app: :gothamapi,
      module: Gothamapi.Guardian,
      error_handler: Gothamapi.Guardian.AuthErrorHandler

  plug(Guardian.Plug.VerifyHeader, claims: @claims, realm: "Bearer")
  plug(Guardian.Plug.EnsureAuthenticated)
  plug(Guardian.Plug.LoadResource, ensure: true)
end