require 'csv'

class AlumnosController < ApplicationController
  def index
    @alumnos = Alumno.all
  end

  def cargar
  end

  def doCargar
    i = 0

    file_path = params[:csv].path
    csv = CSV.read(file_path, :encoding => 'windows-1251:utf-8')
    csv.each do |alumno_csv|

      if i > 0
        rut = alumno_csv[0] + "-" + alumno_csv[1]
        nombre = alumno_csv[4] + " " + alumno_csv[2] + " " + alumno_csv[3]
        carrera_id = alumno_csv[5]
        ingreso_ano = alumno_csv[6]
        ingreso_semestre = alumno_csv[7]
        grupo = alumno_csv[12]
        seccion = alumno_csv[13]

        alumno = Alumno.find_by_rut(rut)

        if not alumno
          alumno = Alumno.new()
        end

        alumno.rut = rut
        alumno.nombre = nombre
        alumno.carrera_id = carrera_id
        alumno.ingreso_ano = ingreso_ano
        alumno.ingreso_semestre = ingreso_semestre
        alumno.grupo = grupo
        alumno.seccion = seccion

        alumno.save!
      end

      i += 1
    end

    redirect_to action: "index", notice: "CSV cargado correctamente"
  end
end
