class UsersController < ApplicationController

  def index
  	@users = User.all
  end

  def agregar
  	@user = User.new
  end

  def doAgregar
    begin
    	@user = User.new user_params
    	@user.save!
    rescue ActiveRecord::RecordInvalid => e
      redirect_to action: "index", error: "El e-mail ya existe en la base de datos"
      return
    end

    redirect_to action: "index", notice: "Usuario agregado correctamente"
  end

  def editar
  	@user = User.find_by_id params[:id]
  end

  def doEditar
  	@user = User.find_by_id params[:id]
    logger.debug @user.id
    if params[:user][:password] != ''
  		@user.update_attributes user_params_edit
  	end
    
    admin = params[:user][:admin]
    @user.update_attribute(:admin, admin)

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
  end

  private
  def user_params
    params.require(:user).permit(:email, :password, :password_confirmation, :admin)
  end
  def user_params_edit
    params.require(:user).permit(:password, :password_confirmation, :admin)
  end
  def user_params_no_passwd
    params.require(:user).permit(:admin)
  end
end
