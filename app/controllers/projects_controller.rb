class ProjectsController < ApplicationController

  before_action :reload, only: [:reports]

  def index
    @company = Company.find(params[:company_id])
    @projects = @company.projects.order(created_at: :desc)
  end

  def new
    @company = Company.find(params[:company_id])
    @project = Project.new
    @project_head_onboarding = @project.project_head_onboardings.build
    @client = Client.new
  end

  def create
    @company = Company.find(params[:company_id])
    @project = Project.new(project_params)
    if @project.save
      flash[:success] = 'Project Created'
      redirect_to company_projects_url(@company)
    else
      render action: :new
    end

  end

  def edit
    @company = Company.find(params[:company_id])
    @project = Project.find(params[:id])
    @proj_head = @project.project_head_onboardings.build
    @proj_employee = @project.onboardings.build
  end

  def update
    @company = Company.find(params[:company_id])
    @project = Project.find(params[:id])
    if @project.update_attributes(project_params)
      flash[:success] = 'Project Updated'
      render action: :edit
    else
      render action: :edit
    end
  end

  def create_client
    @company = Company.find(params[:company_id])
    @onboardings = Onboarding
      .where(
        employment_id: @current_employment,
        end_date: nil
        )
    @client = Client.new(client_params)
    if @client.save
      flash[:success] =  @client.name + " is created as a Client"
      redirect_to new_company_project_url(@company)
    else
      flash[:success] =  "Failed to create client"
      render action: :new
    end
  end

  def enter_time
    @company = Company.find(params[:company_id])
    @onboardings = Onboarding
      .where(
        employment_id: @current_employment,
        end_date: nil
        )
      .order(created_at: :desc)
  end

  def entered_time
    @company = Company.find(params[:company_id])
    @onboardings = Onboarding
      .where(
        employment_id: @current_employment,
        end_date: nil
        )

  end

  def reports
    @company = Company.find(params[:company_id])
    @onboardings = Onboarding
      .where(
        employment_id: @current_employment,
        end_date: nil
        )
    # @employees = Employment.where(company_id: @current_company)
    # @projects = Project
      # .where("departments.company.id == ?", @current_company)

    # dates
    @start_date = params[:start_date] if params[:start_date].present?
    @end_date = params[:end_date] if params[:start_date].present?
    @start_date = Date.new(params[:reference][:year].to_i, params[:reference][:month].to_i).at_beginning_of_month if params[:reference].present?
    @end_date = Date.new(params[:reference][:year].to_i, params[:reference][:month].to_i).at_end_of_month if params[:reference].present?


    @type = params[:type]

    @report_onboarding = @current_company.onboardings
    @company_projects = @current_company.projects

    @dates = (@start_date.to_date..@end_date.to_date)
    @timesheet_employee = params[:timesheet_employee][:employment_id] unless params[:timesheet_employee].blank?
    @report_employee = Employment.find_by_id(params[:timesheet_employee][:employment_id]) unless params[:timesheet_employee].blank?

    @report_clients = params[:report_clients][:client_id] unless params[:report_clients].blank?
    @report_clients2 = Client.find_by_id(@report_clients) unless params[:report_clients].blank?
    @client_projects = @report_clients2.projects.order(created_at: :asc) unless @report_clients.blank?

    @report_onboarding_client = @report_clients2.employments.distinct unless @report_clients.blank?


  end

  def reload
    if params[:form_date] == true
      redirect_to reports_company_projects_url(@company, start_date: @stat_date, end_date: @end_date, type: @type , timesheet_employee: {employment_id: @timesheet_employee}, report_clients: {client_id: @report_clients})
    end
  end

  private

  def project_params
    params.require(:project).permit(
      :id,
      :name,
      :department_id,
      :client_id,
      project_head_onboardings_attributes: [
        :id,
        :employment_id,
        :department_id,
        :project_id,
        :start_date,
        :end_date
      ],
      onboardings_attributes: [
        :id,
        :employment_id,
        :project_id,
        :start_date,
        :end_date
      ]
    )
  end

  def client_params
    params.require(:client).permit(
      :id,
      :name,
      :company_id
    )
  end
end
