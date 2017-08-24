class PagesController < ApplicationController
	before_action :set_up
  
  def index
  	@company = Company.find(params[:id])
  	@holidays = @company.holidays
  end

  def new
  	@holiday = @company.holidays.build
  end

  def create
  	@holiday = @company.holidays.build(:holiday_params)
  end

  def edit
  end

  def update
  end

  def destroy
  end

	private

	def set_up
		if user_signed_in?
			@user = current_user
			@employment = @user.employments.last
			@employments = @user.employments
			@company = Company.find(params[:id])
		end

	def holiday_params
		params.require(:holidays).permit(
			:id,
			:name,
			:date,
			)
	end
end