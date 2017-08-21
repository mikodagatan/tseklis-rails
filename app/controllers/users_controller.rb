class UsersController < ApplicationController
  before_action :authenticate_user!

  def show
    @user = User.find( params[:id] )


    if @employments.present?
      @employments = @user.employments
      @employment = @user.employments.find(params[:id])
      @company = @employment.company
      @leave_requests = @employment.leave_requests
      @leave_request = @employment.leave_requests.find_by_id( params[:id] )
    end

    if @leave_requests.present?
      @leave_types = @company.leave_types
    end
  end

  def edit
  end

  def index
  	@users = User.all
	end
end
