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
    if user_signed_in?
      @current_user = current_user

      if @current_user.employments.present?
        @current_employments = @current_user.employments
        if @current_employments.find_by(company_id: params[:id]).present?
          @current_employment = @current_employments.find_by(company_id: params[:id])
        elsif @current_employments.find_by_id(params[:employment_id]).present?
           @current_employment = @current_employments.find_by_id(params[:employment_id])
        else
        end
       
        @current_companies = @current_user.companies
        @current_company = @current_companies.find_by_id( params[:id])
      end
    end
  end

end
