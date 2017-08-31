class UsersController < ApplicationController
  before_action :authenticate_user!
  before_action :set_up

  def show
    if @user.employments.present?
      @companies = @user.companies.distinct
    end
  end

  def edit
  end

  def index
  	@users = User.all
	end

  def set_up
    @user = User.find(params[:id])
    @employments = @user.employments
    @leave_requests = @user.leave_requests
  end

end
