class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  before_action :configure_permitted_parameters, if: :devise_controller?

  before_action :user_roles

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

  def user_roles
    @administrator = UserRole.find(1)
    @hr_officer = UserRole.find(2)
    @employee = UserRole.find(3)
  end
end