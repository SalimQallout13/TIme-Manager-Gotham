defmodule GothamapiWeb.Router do
  use GothamapiWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, {GothamapiWeb.LayoutView, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug CORSPlug,
         origin: ~r/http:\/\/localhost:8080|https:\/\/.*\.xxx$/,
         allow_headers: [
           "Access-Control-Allow-Origin",
           "Authorization",
           "Content-Type",
           "Accept",
           "Origin",
           "User-Agent",
           "DNT",
           "Cache-Control",
           "X-Mx-ReqToken",
           "Keep-Alive",
           "X-Requested-With",
           "If-Modified-Since",
           "Bearer",
           "X-File-Name"
         ]
    plug :accepts, ["json"]

  end

  pipeline :auth do
    plug Gothamapi.Guardian.AuthPipeline
  end

  scope "/api", GothamapiWeb do
    pipe_through :api

    post "/users/", UsersController, :create
    post "/session/new", SessionController, :new


  end


  # Other scopes may use custom stacks.
  scope "/api", GothamapiWeb do
    pipe_through [:api, :auth]

    post "/session/refresh", SessionController, :refresh
    post "/session/delete", SessionController, :delete

    scope "/users" do
      get "/", UsersController, :index
      get "/search", UsersController, :indexBy
      get "/:userID", UsersController, :show
      put "/:userID", UsersController, :update
      delete "/:userID", UsersController, :delete
    end

    scope "/workingtimes" do
      get "/", WorkingtimesController, :index
      get "/search", WorkingtimesController, :indexBy
      get "/:id", WorkingtimesController, :show
      post "/:userID", WorkingtimesController, :create
      put "/:id", WorkingtimesController, :update
      delete "/:id", WorkingtimesController, :delete
    end

    scope "/clocks" do
      get "/", ClocksController, :index
      get "/search", ClocksController, :indexBy
      get "/:id", ClocksController, :show
      post "/:userID", ClocksController, :create
    end

  end

  # Enables LiveDashboard only for development
  #
  # If you want to use the LiveDashboard in production, you should put
  # it behind authentication and allow only admins to access it.
  # If your application does not have an admins-only section yet,
  # you can use Plug.BasicAuth to set up some basic authentication
  # as long as you are also using SSL (which you should anyway).
end
