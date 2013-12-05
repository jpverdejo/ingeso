class UsersController < ApplicationController

  before_filter { |controller| 
  return
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
  	@users = User.all
  end

  def agregar
  	@user = User.new
  end

  def doAgregar
  	@user = User.new user_params
  	@user.save!

    redirect_to action: "index", notice: "Usuario agregado correctamente"
  end

  def editar
  	@user = User.find_by_id params[:id]
  end

  def doEditar
  	@user = User.find_by_id params[:id]

  	if params[:user][:password] != ''
  		@user.update_attributes user_params
  	else 
  		@user.update_attributes user_params_no_passwd
  	end

  	@user.save!

    redirect_to action: "index", notice: "Usuario editado correctamente"
  end

  def eliminar
  	if params[:id].to_i != current_user.id.to_i
  		User.find_by_id(params[:id]).delete
  		redirect_to action: "index", notice: "Usuario eliminado correctamente"
  		return
  	end
  	
  	redirect_to action: "index", error: "No puede eliminarse a si mismo"
  end

  def new
    logger.debug "asdfas"
  end

  private
  def user_params
    params.require(:user).permit(:email, :password, :password_confirmation, :admin)
  end
  def user_params_no_passwd
    params.require(:user).permit(:email, :admin)
  end
end
