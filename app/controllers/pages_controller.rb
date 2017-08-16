class PagesController < ApplicationController
	before_action :set_up
  
  def home
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


