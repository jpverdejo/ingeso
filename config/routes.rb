Ingeso::Application.routes.draw do
  get "users", to: "users#index"
  get "users/index"

  get "users/agregar"
  post "users/agregar", to: "users#doAgregar"

  get "users/:id/editar", to: "users#editar"
  post "users/:id/editar", to: "users#doEditar"

  delete "users/:id/eliminar", to: "users#eliminar", as: "delete_user"

  devise_for :users
  
  # Alumnos
  get "alumnos", to: "alumnos#index"
  get "alumnos/index"

  get "alumnos/revisar", to: "alumnos#revisar"

  get "alumnos/cargar"
  post "alumnos/cargar", to: "alumnos#doCargar"

  get "alumnos/cargarFotos"
  post "alumnos/cargarFotos", to: "alumnos#doCargarFotos"

  get "alumnos/agregar"
  post "alumnos/agregar", to: "alumnos#doAgregar"

  get "alumnos/:id/editar", to: "alumnos#editar"
  post "alumnos/:id/editar", to: "alumnos#doEditar"

  
  # Pruebas
  get "pruebas", to: "pruebas#index"
  get "pruebas/index"

  get "pruebas/agregar"
  post "pruebas/agregar", to: "pruebas#doAgregar"

  get "pruebas/:id/editar", to: "pruebas#editar"
  post "pruebas/:id/editar", to: "pruebas#doEditar"

  root "alumnos#index"


end
