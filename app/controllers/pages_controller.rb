class PagesController < ApplicationController
	before_action :set_up
  
  def home
    @hr_officer = Role.find(1)
    @employee = Role.find(2)
  	@administrator = Role.find(653555391)
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


