class EmploymentsController < ApplicationController

	def edit
		@user = User.find(current_user.id)
	end

	def update

	

		# @user.employments.includes(:company).each do |employment|
  # 		@company = employment.Company
  # 	end
  end

end