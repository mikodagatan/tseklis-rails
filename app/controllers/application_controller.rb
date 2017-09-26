require "application_responder"

class ApplicationController < ActionController::Base
  self.responder = ApplicationResponder
  respond_to :html

  protect_from_forgery with: :exception

  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :roles
  before_action :current_user_set

  helper ApplicationHelper

  helper_method :employed_here?, :employed?, :hr?, :accepted?

  def employed_here?
    @current_company.present?
  end

  def employed?
    @current_employment.present? || @current_employments.present?
  end

  def accepted?
    @current_employments.present? && @current_employments.where(acceptance: true).present?
  end

  def hr?
    @current_employment.is_hr?
  end

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
    @hr_officer = Role.find(1)
    @employee = Role.find(2)
  end


  def current_user_set
    if user_signed_in?
      @current_user = current_user

      if @current_user.employments.present?
        @current_employments = @current_user.employments
        @current_employment = @current_employments.find_by(company_id: params[:id]) || @current_employments.find_by(company_id: params[:company_id])
        @current_companies = @current_user.companies
        @current_company = @current_companies.find_by_id(params[:id]) || @current_companies.find_by_id(params[:company_id]) if params[:controller] == 'companies' && (params[:action] != 'new' && params[:action] != 'create')
      end
    end
  end



end
