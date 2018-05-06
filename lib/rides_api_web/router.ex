defmodule RidesApiWeb.Router do
  use RidesApiWeb, :router

  pipeline :api do
    plug(:accepts, ["json"])
  end

  # Pattern match on the path prefix 
  # (Note we include a version number for good form)
  scope "/feed/v1", RidesApiWeb do
    # Use the api stack
    pipe_through(:api)

    # Depending on the path resource paths we dispatch properly
    # Only support the index action currently
    get("/kamakurashares", KamakuraController, :index)
    get("/ginzarides", GinzaController, :index)
  end
end
