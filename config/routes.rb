Ingeso::Application.routes.draw do
  # Alumnos
  get "alumnos/index"
  get "alumnos/cargar"
  post "alumnos/cargar", to: "alumnos#doCargar"

  root "alumnos#index"
end
