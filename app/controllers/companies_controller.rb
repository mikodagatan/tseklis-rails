class LeaveRequestsController < ApplicationController

def new
	@user = User.find(current_user)
	@company = Company.new
end

def new

end

def edit
end

end
