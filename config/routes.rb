Ingeso::Application.routes.draw do
  get "users", :to => "users#index"
  get "users/index"

  get "users/agregar"
  post "users/agregar", :to => "users#doAgregar"

  get "users/:id/editar", :to => "users#editar"
  post "users/:id/editar", :to => "users#doEditar"

  delete "users/:id/eliminar", :to => "users#eliminar", :as => "delete_user"

  devise_for :users
  
  # Alumnos
  get "alumnos", :to => "alumnos#index"
  get "alumnos/index"

  get "alumnos/cargar"
  post "alumnos/cargar", :to => "alumnos#doCargar"

  get "alumnos/cargarFotos"
  post "alumnos/cargarFotos", :to => "alumnos#doCargarFotos"

  get "alumnos/agregar"
  post "alumnos/agregar", :to => "alumnos#doAgregar"

  get "alumnos/:id/editar", :to => "alumnos#editar"
  post "alumnos/:id/editar", :to => "alumnos#doEditar"

  
  # Pruebas
  get "pruebas", :to => "pruebas#index"
  get "pruebas/index"

  get "pruebas/agregar"
  post "pruebas/agregar", :to => "pruebas#doAgregar"

  get "pruebas/:id/editar", :to => "pruebas#editar"
  post "pruebas/:id/editar", :to => "pruebas#doEditar"

  delete "pruebas/:id/eliminar", :to => "pruebas#eliminar", :as => "delete_prueba"

  get "pruebas/:id/administrar", :to => "pruebas#administrar", :as => "administrar_prueba"
  post "pruebas/:id/sala", :to => "pruebas#agregarSala", :as => "agregar_sala"
  delete "pruebas/:prueba/alumno/:alumno", :to => "pruebas#desinscribirAlumno", :as => "desinscribir_alumno"

  post "pruebas/:id/inscribir", :to => "pruebas#inscribirAlumnos", :as => "inscribir_alumnos"

  get "pruebas/:id/imprimirListado", :to => "pruebas#imprimirListado", :as => "imprimir_listado"
  get "pruebas/:id/imprimirListadoFirmas", :to => "pruebas#imprimirListadoFirmas", :as => "imprimir_listado_firmas"

  get "pruebas/revisar", :to => "pruebas#revisar", :as => "revisar"
  post "pruebas/revisar", :to => "pruebas#revisarPrueba", :as => "revisar_prueba"

  root "alumnos#index"


end
