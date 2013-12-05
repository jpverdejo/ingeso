class PruebasController < ApplicationController

  before_filter { |controller| 
    if user_signed_in?
      if current_user.admin?
        return true
      else
        redirect_to controller: "alumnos", action: "revisar", error: "No tiene permisos suficientes"
        return
      end
    end

    redirect_to new_user_session_path, error: "No tiene permisos suficientes" 
    return
  }
  
  def index
    @pruebas = Prueba.all
  end

  def doAgregar
    fechahora = DateTime.strptime(params[:prueba][:fecha], '%d/%m/%Y %H:%M').strftime("%Y/%m/%d %H:%M")

    prueba = Prueba.new(prueba_params)
    prueba.fecha = fechahora
    prueba.save!

    redirect_to action: "index", notice: "Prueba agregada correctamente"
  end

  def editar
    @prueba = Prueba.find_by_id params[:id]
  end

  def doEditar
    fechahora = DateTime.strptime(params[:prueba][:fecha], '%d/%m/%Y %H:%M').strftime("%Y/%m/%d %H:%M")

    prueba = Prueba.find_by_id params[:id]
    prueba.update_attributes prueba_params
    prueba.fecha = fechahora
    prueba.save!

    redirect_to action: "index", notice: "Prueba agregada correctamente"
  end

  def eliminar
    Prueba.find_by_id(params[:id]).delete
    redirect_to action: "index", notice: "Prueba eliminado correctamente"
  end

  def administrar
    @prueba = Prueba.find_by_id params[:id]
    @alumnos = Alumno.all - @prueba.alumnos
  end

  def agregarSala
    prueba = Prueba.find_by_id params[:id]

    sala = Sala.new sala_params
    sala.prueba = prueba
    sala.save!

    redirect_to administrar_prueba_path, id: prueba, notice: "Sala agregada correctamente."
  end

  def desinscribirAlumno
    inscripcion = Inscripcion.find_by_prueba_id_and_alumno_id(params[:prueba], params[:alumno]).delete

    prueba = Prueba.find_by_id params[:prueba]

    redirect_to administrar_prueba_path id: prueba, notice: "Usuario desasignado correctamente."
  end

  def inscribirAlumnos
    counter = 0

    sala = Sala.find_by_id params[:prueba][:sala]
    logger.debug(sala)
    prueba = Prueba.find_by_id params[:id]
    
    alumnos = params[:prueba][:alumnos].split(",")
    
    alumnos.each do |alumno_id|
      if Inscripcion.find_all_by_sala_id(sala).count >= sala.capacidad
        break
      end

      alumno = Alumno.find_by_id alumno_id

      inscripcion = Inscripcion.new
      inscripcion.sala = sala
      inscripcion.alumno = alumno
      inscripcion.prueba = prueba 
      inscripcion.save!

      counter += 1
    end

    if counter < alumnos.count 
      message = "Sala llena! Solo se asignaron #{counter} alumnos a la sala."
      redirect_to administrar_prueba_path id: prueba, notice: message
      return
    end
    
    message = "Los alumnos seleccionados fueron asignados correctamente."
    redirect_to administrar_prueba_path id: prueba, notice: message
  end

  def imprimirListado
    @prueba = Prueba.find_by_id(params[:id])
    @inscripciones = Inscripcion.find_all_by_prueba_id(@prueba, :include => [:alumno,:sala], :order => 'alumnos.rut')
    #:include => [:editor,:author], :order => 'authors_articles.name'
    render :layout => "listados"
  end

  def imprimirListadoFirmas
    @prueba = Prueba.find_by_id params[:id]
    render :layout => "listados"
  end

  private
  def prueba_params
    params.require(:prueba).permit(:titulo, :fecha)
  end

  def sala_params
    params.require(:sala).permit(:nombre, :capacidad)
  end
end
