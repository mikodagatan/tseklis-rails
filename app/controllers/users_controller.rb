class UsersController < ApplicationController
  before_action :authenticate_user!
  before_action :set_up

  def show
    @user = User.find( params[:id] )


    if @user.employments.present?
      @employment = @user.employments.find(params[:id])
      @company = @employment.company
      @leave_requests = @employment.leave_requests
      @leave_request = @employment.leave_requests.find_by_id( params[:id] )
      @current_employment = @current_employments.find_by(company_id: @company.id)
      @current_company = @current_employment.company

      if @user.leave_amounts.where("leave_requests.acceptance = true").present?
        # to change for multiple companies
        @company = @current_user.employments.last.company
        @leaves = []
        @month_segmented_leaves = @user.segmented_leaves(Date.today.all_month, @company)
        @month_total_leaves = @user.total_leaves(Date.today.all_month, @company)
        @available_leaves = @user.available_leaves(@company)

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
