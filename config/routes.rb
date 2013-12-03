Ingeso::Application.routes.draw do
  # Alumnos
  get "alumnos", to: "alumnos#index"
  get "alumnos/index"

  get "alumnos/cargar"
  post "alumnos/cargar", to: "alumnos#doCargar"

  get "alumnos/cargarFotos"
  post "alumnos/cargarFotos", to: "alumnos#doCargarFotos"

  get "alumnos/agregar"
  post "alumnos/agregar", to: "alumnos#doAgregar"

  get "alumnos/:id/editar", to: "alumnos#editar"
  post "alumnos/:id/editar", to: "alumnos#doEditar"

  root "alumnos#index"
end
