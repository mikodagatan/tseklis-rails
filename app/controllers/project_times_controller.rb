class ProjectTimesController < ApplicationController
  helper ApplicationHelper

  def create
    @company = Company.find(params[:company_id])
    if ProjectTime.create(project_time_params2)
      flash[:success] = "Project times have been saved"
      redirect_to company_projects_url(@company)
    else
      redirect_to enter_time_company_projects_url(@company)
    end
  end

  def update
    @company = Company.find(params[:company_id])
    @onboardings = Onboarding
      .where(
        employment_id: @current_employment,
        end_date: nil
        )
    count = 0
    # @onboardings.count.times do
    #   ProjectTime.new(
    #     onboarding_id: params[:project_times][count][:onboarding_id],
    #     project_id: params[:project_times][count][:project_id],
    #     duration: params[:project_times][count][:duration],
    #     date: default_date(params[:project_times][count][:date])
    #   ).save
    # end


    @project_time.date = default_date(@project_time.date)
    if @project_time.save
      flash[:success] = "Project times have been saved"
      redirect_to company_projects_url(@company)
    else
      flash[:alert] = @project_time.errors.full_messages
      redirect_to enter_time_company_projects_url(@company)
    end
  end

  private
  def project_time_params
    params.require(:project_times).permit(
      array:
        [:id,
        :onboarding_id,
        :project_id,
        :duration,
        :date]
    )
  end

  def project_time_params2
    params.require(:project_times).map do |p|
      p.permit(
        :id,
        :onboarding_id,
        :project_id,
        :duration,
        :date
      )
    end
  end
end
