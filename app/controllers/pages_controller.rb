class PagesController < ApplicationController
	before_action :set_up

  def home
  	if user_signed_in?
			@companies = @current_user.companies.distinct if @current_user.companies.present?
			@connections = Employment.select('DISTINCT (user_id, company_id)').count
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
