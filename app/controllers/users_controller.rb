class UsersController < ApplicationController
  before_action :authenticate_user!
  before_action :set_up, only: :show

  def show
    @per_show = 10
    if @user.employments.present?
      @companies = @user.companies.distinct
      @companies_accepted = @companies.where('employments.acceptance = true').distinct
      # Checking if there are companies with leave types
      count = 0
      @companies.each { |u| u.leave_types.present? ? count += 1 : count += 0}
      @has_leave_types = count > 0 ? true : false
      count2 = 0
      @companies.each { |u| u.leave_requests.where('employments.user_id = ?', @current_user.id).count > 0 ? count2 += 1 : count2 += 0 }
      @has_leave_requests = count2 > 0
    end
    if @leave_requests.present?
      @leave_requests = @user.leave_requests.reverse_order
      @leave_requests = Kaminari.paginate_array(@leave_requests).page(params[:leave_requests_page]).per(@per_show)
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
