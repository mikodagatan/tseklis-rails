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
      ]
    )
  end
end
