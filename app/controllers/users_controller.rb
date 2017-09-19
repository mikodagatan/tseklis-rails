class UsersController < ApplicationController
  before_action :authenticate_user!
  before_action :set_up

  def show
    if @user.employments.present?
      @companies = @user.companies.distinct
      # Checking if there are companies with leave types
      count = 0
      @companies.each { |u| u.leave_types.present? ? count += 1 : count += 0}
      @has_leave_types = count > 0 ? true : false
    end
    if @leave_requests.present?
      @leave_requests = @user.leave_requests.reverse_order
      @leave_requests = Kaminari.paginate_array(@leave_requests).page(params[:page]).per(2)
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
