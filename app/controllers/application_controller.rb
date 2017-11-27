require "application_responder"

class ApplicationController < ActionController::Base
  self.responder = ApplicationResponder
  respond_to :html

  protect_from_forgery with: :exception

  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :roles
  before_action :current_user_set
  around_action :user_time_zone, if: :user_signed_in

  helper ApplicationHelper

  helper_method :employed_here?, :employed?, :hr?, :accepted?, :manager?, :user_signed_in, :user_time_zone, :project_manager?, :department_manager?, :current_department_manager, :present_employment?

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

  def manager?
    @current_employment.is_manager?
  end

  def present_employment?
    @current_employment.present?
  end

  def user_signed_in
    user_signed_in?
  end

  def user_time_zone(&block)
    Time.use_zone(current_user.time_zone, &block)
  end

  def project_manager?
    ProjectHeadOnboarding.find_by(employment_id: @employment).present?
  end

  def department_manager?
    DepHeadOnboarding.find_by(employment_id: @employment).present?
  end

  def current_department_manager
    self.dep_head_onboardings.where(end_date: nil).last.employment
  end

  def this_project_manager?
    self.current_project_manager == @employment
  end

  def this_department_manager?
    self.current_department_manager == @employment
  end
  protected

  def configure_permitted_parameters
    attrs = [:name,
            :email,
            :time_zone,
            :password,
            :password_confirmation,
            :current_password,
            profile_attributes: [:id,
                              :first_name,
                              :last_name],
            employments_attributes: [:id,
                                    :start_date,
                                    :end_date,
                                    :company_id,
                                    :user_id,
                                    :role_id,
                                    :salary]
                                  ]
    devise_parameter_sanitizer.permit :sign_up, keys: attrs
    devise_parameter_sanitizer.permit :account_update, keys: attrs
  end

  def roles
    @hr_officer = Role.find(1)
    @employee = Role.find(2)
    @manager = Role.find(3)
  end


  def current_user_set
    if user_signed_in?
      @current_user = current_user

      if @current_user.employments.present?
        @current_employments = @current_user.employments
        @current_employment = @current_employments.where(company_id: params[:company_id], acceptance: true).first
        @current_employment = @current_employments.where(company_id: params[:id], user_id: @current_user.id, acceptance: true).first if @current_employment.blank?
        @current_companies = @current_user.companies
        @current_company = @current_companies.find_by_id(params[:id]) || @current_companies.find_by_id(params[:company_id]) if params[:controller] == 'companies' && (params[:action] != 'new' && params[:action] != 'create')
        @current_company = Company.find_by_id(params[:company_id]) if @current_company.nil?
      end
    end
  end





end
