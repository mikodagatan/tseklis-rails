class ProjectsController < ApplicationController

  def index
    @company = Company.find(params[:company_id])
    @projects = @company.projects
  end

  def new
    @company = Company.find(params[:company_id])
    @project = Project.new
    @project_head_onboarding = @project.project_head_onboardings.build
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

  def enter_time
    @company = Company.find(params[:company_id])
    @onboardings = Onboarding
      .where(
        employment_id: @current_employment,
        end_date: nil
        )
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
    @report_onboarding = @current_company.onboardings
    @start_date = Time.zone.today.beginning_of_month
    @end_date = Time.zone.today.end_of_month
  end

  private

  def project_params
    params.require(:project).permit(
      :id,
      :name,
      :department_id,
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
end
