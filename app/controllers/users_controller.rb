class UsersController < ApplicationController
  before_action :authenticate_user!
  before_action :set_up

  def show
    if @user.employments.present?
      @companies = @user.companies.distinct
      if @user.leave_amounts.where("leave_requests.acceptance = true").present?
        # to change for multiple companies
        @leaves = []
        @month_segmented_leaves = @user.segmented_leaves(Date.today.all_month, @company)
        @month_total_leaves = @user.total_leaves(Date.today.all_month, @company)
        @all_available_leaves = @user.all_available_leaves(@company)
      end
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

  def set_up
    @user = User.find(params[:id])
    @employments = @user.employments
    @leave_requests = @user.leave_requests
  end

end
