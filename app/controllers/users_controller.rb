class UsersController < ApplicationController
  before_action :authenticate_user!

  def show
    @user = User.find( params[:id] )
    @employments = @user.employments
    @employment = @user.employments.last

    if @employments.exists?
      @leave_requests = @employment.leave_requests
    end
  end

  def edit
  end

  def index
  	@users = User.all
	end
end
