class AddLeavesController < ApplicationController

  def new
    @employment = Employment.find(params[:employment_id])
    @leave_types = @employment.company.leave_types
    @add_leave = AddLeafe.new
  end

  def create
    @add_leave = AddLeafe.new(add_leave_params)
    @employment = Employment.find(params[:employment_id])
    @add_leave.employment = @employment
    if @add_leave.save
      flash[:success] = "Successfully added #{@add_leave.amount} leave/s to #{@add_leave.leave_type.name} leave for #{@employment.user.profile.first_name} #{@employment.user.profile.last_name}"
      redirect_to company_url(@employment.company)
    else
      render action: :new
    end
  end

protected

  def add_leave_params
    params.require(:add_leafe).permit(
      :id,
      :amount,
      :employment_id,
      :leave_type_id
    )
  end
end
