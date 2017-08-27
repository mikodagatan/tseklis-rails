class PagesController < ApplicationController
	before_action :set_up
  
  def home
  	if user_signed_in?
	  	if current_user.leave_amounts.present?
	  		# to change for multiple companies
	  		@company = @current_user.employments.last.company
		  	@leaves = []
				@month_segmented_leaves = current_user.segmented_leaves(Date.today.all_month, @company)
				@month_total_leaves = current_user.total_leaves(Date.today.all_month, @company)
			end
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


