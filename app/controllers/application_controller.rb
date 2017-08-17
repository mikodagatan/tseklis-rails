class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :roles
  before_action :current_user_set

  protected

  def configure_permitted_parameters
   				

    attrs = [:name, 
            :email, 
            :password, 
            :password_confirmation,
            :current_password,
            profile_attributes: [:id, 
                              :first_name, 
                              :last_name]]
    devise_parameter_sanitizer.permit :sign_up, keys:attrs
    devise_parameter_sanitizer.permit :account_update, keys: attrs
  end

  def roles
    @administrator = Role.find(653555391)
    @hr_officer = Role.find(1)
    @employee = Role.find(2)
  end

  def current_user_set
    @c_user = current_user
    if @c_user.employments.exists?
      @c_employments = @c_user.employments
      
    end
  end  
end
