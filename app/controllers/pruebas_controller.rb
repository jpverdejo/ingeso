class PruebasController < ApplicationController
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

  private
  def prueba_params
    params.require(:prueba).permit(:titulo, :fecha)
  end
end
