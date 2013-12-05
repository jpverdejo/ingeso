class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  before_filter { |controller| 

  	if params[:error]
  		flash.now[:error] = params[:error]
  	end
  	if params[:notice]
  		flash.now[:notice] = params[:notice]
  	end
  }

  before_filter :configure_devise_params, if: :devise_controller?
    def configure_devise_params
      devise_parameter_sanitizer.for(:account_update) do |u|
        u.permit(:admin, :email, :password, :password_confirmation)
      end
    end



  before_filter { |controller| 
    if controller.controller_name == 'sessions' and (controller.action_name == 'new' or controller.action_name == 'create' or controller.action_name == 'destroy')
      return true
    end

    if user_signed_in?
      if controller.controller_name == 'sessions'
        return true
      end
      if (not (controller.controller_name == "pruebas" and (controller.action_name == 'revisar' or controller.action_name == 'revisarPrueba'))) and current_user.admin?
        return true
      else
        if controller.controller_name == "pruebas" and (controller.action_name == 'revisar' or controller.action_name == 'revisarPrueba')
          return true
        else
          redirect_to revisar_path, error: "No tiene permisos suficientes" 
          return
        end
      end
    end

    redirect_to new_user_session_path, error: "No tiene permisos suficientes" 
    return
  }



  layout :layout_by_resource

  def layout_by_resource
    if devise_controller? && resource_name == :user && action_name == 'new'
      "login"
    else
      "application"
    end
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

    return nil if rut != rut.tr('^0-9', '')
    return nil if dv != dv.tr('^0-9K', '')
    return nil if dv.to_s.upcase != self.get_digito(rut).to_s.upcase

    return "#{rut}-#{dv}"
  end

end
