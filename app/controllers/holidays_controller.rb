class HolidaysController < ApplicationController
	before_action :set_up
  
  def index
  	@holidays = @company.holidays
  end

  def new
  	@holiday = @company.holidays.build
  end

  def create
  	@holidays = @company.holidays
  	@holiday = @company.holidays.build(holiday_params)
  	if @holiday.save
  		flash[:success] = "Holiday Created!"
  		redirect_to company_holidays_url(@company, @holidays)
  	else
  		render action: :new
  	end
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
			@company = Company.find(params[:company_id])
		end
	end

	def holiday_params
		params.require(:holiday).permit(
			:id,
			:name,
			:date,
			)
	end
end