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

  def edit
    @company = Company.find(params[:company_id])
    @department = Department.find(params[:id])
    @dep_head = @department.dep_head_onboardings.build
  end

  def update
    @company = Company.find(params[:company_id])
    @department = Department.find(params[:id])
    if @department.update_attributes(department_params)
      flash[:success] = "Department Updated"
      render action: :edit
    else
      render action: :edit
    end
  end

  def destroy
  end

  private

  def department_params
    params.require(:department).permit(
      :id,
      :name,
      dep_head_onboardings_attributes: [
        :id,
        :employment_id,
        :department_id,
        :start_date,
        :end_date,
        :_destroy
      ]
    )
  end

  def destroy_dep_head_onboarding_blank
    @department = Department.find(params[:id])
    dep_heads = @department.dep_head_onboardings
		dep_heads.each do |dep_head|
			DepHeadOnboarding.destroy(dep_head.id) if dep_head[:id].nil? || (dep_head[:employment_id].nil?)
		end
  end

  def mark_dep_head_onboarding_for_removal
    @department = Department.find(params[:id])
    dep_heads = @department.dep_head_onboardings
    dep_heads.each do |child|
      child.mark_for_destruction if child.employment_id.blank?
    end
  end

end
