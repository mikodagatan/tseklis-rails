class PagesController < ApplicationController
	before_action :set_up

  def home
  	if user_signed_in?
			@companies = @current_user.companies.distinct if @current_user.companies.present?
			@connections = Employment.select('DISTINCT (user_id, company_id)').count
      # has_leave_types
      count = 0
      @companies.each { |u| u.leave_types.present? ? count += 1 : count += 0}
      @has_leave_types = count > 0 ? true : false
		end
  end

  def about
  end

end

private

def set_up
	if user_signed_in?
		@user = current_user
		@employment = @user.employments.last
		@employments = @user.employments
	end
end
