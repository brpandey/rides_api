defmodule RidesApiWeb.Router do
  use RidesApiWeb, :router

  pipeline :api do
    plug(:accepts, ["json"])
  end

  scope "/feed/v1", RidesApiWeb do
    # Use the api stack
    pipe_through(:api)

    get("/kamakurashares", KamakuraController, :index)
    get("/ginzarides", GinzaController, :index)
  end
end
