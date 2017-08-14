class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  before_action :configure_permitted_parameters, if: :devise_controller?

    def configure_permitted_parameters
  	devise_parameter_sanitizer.permit(:sign_up) { |u| u.permit(
   				:name, 
  				:email, 
  				:password, 
  				:password_confirmation, 
  				profile_attributes: [:id, 
  														:first_name, 
  														:last_name, 
  														:position]) }
  end
end
