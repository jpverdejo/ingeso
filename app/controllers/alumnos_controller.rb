require 'csv'
require 'zip'

class AlumnosController < ApplicationController
  before_filter { |controller| 
    if user_signed_in?
      if controller.action_name != 'revisar' and current_user.admin?
        return true
      else
        if controller.action_name == 'revisar'
          return true
        else
          redirect_to action: "revisar", error: "No tiene permisos suficientes" 
          return
        end
      end
    end

    redirect_to controller: "sessions", action: "sign_in", error: "No tiene permisos suficientes" 
    return
  }

  def index
    @alumnos = Alumno.all
  end

  def revisar

  end

  def agregar
    @alumno = Alumno.new
  end

  def doAgregar
    if params[:alumno][:foto]
      extension = self.get_image_extension(params[:alumno][:foto].path)
      if ["png", "jpg", "gif"].include?(extension)
        redirect_to action: "agregar", error: "La foto subida no es una imagen correcta" 
        return
      end
    end

    rut = self.get_rut(params[:alumno][:rut])
    if not rut
      redirect_to action: "agregar", error: "RUT incorrecto" 
      return
    end

    @alumno = Alumno.find_by_rut(rut)

    if @alumno
      @alumno.update_attributes(alumno_params)
    else
      @alumno = Alumno.new(alumno_params)
    end
    
    @alumno.save!

    redirect_to action: "index", notice: "Alumno agregado correctamente"
  end

  def editar
    @alumno = Alumno.find(params[:id])
  end

  def doEditar
    @alumno = Alumno.find(params[:id])

    message = "Alumno editado correctamente"

    if not @alumno.update(params[:alumno].permit(:nombre, :carrera_id, :ingreso_ano, :ingreso_semestre, :grupo, :seccion, :foto))
      message = "Hubo problemas al editar el alumno"
    end

    redirect_to action: "index", notice: message
  end

  def cargar
  end

  def doCargar
    i = 0

    @valid_ruts = []
    @invalid_ruts = []
    @updated_ruts = []

    file_path = params[:csv].path
    csv = CSV.read(file_path, :encoding => 'windows-1251:utf-8')
    csv.each do |alumno_csv|

      if i > 0
        rut = self.get_rut(alumno_csv[0] + "-" + alumno_csv[1])
        
        if rut
          @valid_ruts << rut

          nombre = alumno_csv[4] + " " + alumno_csv[2] + " " + alumno_csv[3]
          carrera_id = alumno_csv[5]
          ingreso_ano = alumno_csv[6]
          ingreso_semestre = alumno_csv[7]
          grupo = alumno_csv[12]
          seccion = alumno_csv[13]

          alumno = Alumno.find_by_rut(rut)

          if not alumno
            alumno = Alumno.new()
          else
            @updated_ruts << rut
          end

          alumno.rut = rut
          alumno.nombre = nombre
          alumno.carrera_id = carrera_id
          alumno.ingreso_ano = ingreso_ano
          alumno.ingreso_semestre = ingreso_semestre
          alumno.grupo = grupo
          alumno.seccion = seccion

          alumno.save!

        else
          @invalid_ruts << alumno_csv[0] + "-" + alumno_csv[1]
        end
      end

      i += 1
    end
  end


  def cargarFotos
  end

  def doCargarFotos
    i = 0

    rand_dir = (0...50).map{ ('a'..'z').to_a[rand(26)] }.join
    extract_dir = "#{Rails.root.to_s}/tmp/extract/#{rand_dir}/"
    logger.debug extract_dir
    file_path = params[:zip].path

    Zip::File.open(file_path) do |zip|
      zip.each do |file|
        next if file.name =~ /__MACOSX/ or file.name =~ /\.DS_Store/ or !file.file?
   
        f_path=File.join(extract_dir, file.name)
        FileUtils.mkdir_p(File.dirname(f_path))
        zip.extract(file, f_path)

        extension = self.get_image_extension("#{f_path}")

        if ["png", "jpg", "gif"].include?(extension)
          rut = file.name.partition('.').first

          alumno = Alumno.find_by_rut(rut)

          if alumno
            foto = File.open(f_path)
            alumno.foto = foto
            foto.close
            alumno.save!
          end
        end
      end
    end

    FileUtils.rm_rf extract_dir

    redirect_to action: "index", notice: "ZIP cargado correctamente"
  end

  #Method got from: https://github.com/Numerico/rut-chileno/blob/master/lib/rut_chileno.rb
  def get_digito(rut)
    dvr='0'
    suma=0
    mul=2
    rut.reverse.split("").each do |c|
      suma=suma+c.to_i*mul
      if mul==7
        mul=2
      else
        mul+=1
      end
    end
    res=suma%11
    if res==1
      return 'k'
    elsif res==0
      return '0'
    else
      return 11-res
    end
  end

  def get_rut(rut)
    rut = rut.tr('^A-Za-z0-9', '').upcase

    dv = rut[-1, 1]
    rut = rut[0, (rut.length-1)]

    logger.debug ''
    logger.debug ''
    logger.debug ''
    logger.debug 1
    return nil if rut != rut.tr('^0-9', '')
    logger.debug 2
    return nil if dv != dv.tr('^0-9k', '')
    logger.debug 3 
    logger.debug rut
    logger.debug self.get_digito(rut)
    return nil if dv.to_i != self.get_digito(rut)
    logger.debug 4
    return "#{rut}-#{dv}"
  end

  # Method got from: http://stackoverflow.com/questions/4600679/detect-mime-type-of-uploaded-file-in-ruby
  def get_image_extension(local_file_path)
    png = Regexp.new("\x89PNG".force_encoding("binary"))
    jpg = Regexp.new("\xff\xd8\xff\xe0\x00\x10JFIF".force_encoding("binary"))
    jpg2 = Regexp.new("\xff\xd8\xff\xe1(.*){2}Exif".force_encoding("binary"))
    case IO.read(local_file_path, 10)
      when /^GIF8/
        'gif'
      when /^#{png}/
        'png'
      when /^#{jpg}/
        'jpg'
      when /^#{jpg2}/
        'jpg'
      else
        mime_type = `file #{local_file_path} --mime-type`.gsub("\n", '') # Works on linux and mac
        raise UnprocessableEntity, "unknown file type" if !mime_type
        mime_type.split(':')[1].split('/')[1].gsub('x-', '').gsub(/jpeg/, 'jpg').gsub(/text/, 'txt').gsub(/x-/, '')
    end
  end

  private
  def alumno_params
    params.require(:alumno).permit(:rut, :nombre, :carrera_id, :ingreso_ano, :ingreso_semestre, :grupo, :seccion, :foto)
  end
end
