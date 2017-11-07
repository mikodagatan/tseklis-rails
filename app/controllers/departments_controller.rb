class DepartmentsController < ApplicationController
  def index
    @company = Company.find(params[:company_id])
    @departments = @company.departments
  end

  def new
    @company = Company.find(params[:company_id])
    @department = @company.departments.build
    @dep_head = @department.dep_head_onboardings.build
  end

  def create
    @company = Company.find(params[:company_id])
    @department = @company.departments.build(department_params)
    if @company.save
      flash[:success] = "Created the " + @department.name + " Department"
      redirect_to company_departments_url(@company)
    else
      render action: :new
    end
  end


  private

  def department_params
    params.require(:department).permit(
      :id,
      :name,
      dep_head_onboardings_attributes: [
        :employment_id,
        :department_id,
        :start_date,
        :end_date
      ]
    )
  end
end
