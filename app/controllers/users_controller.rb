class UsersController < ApplicationController
  before_action :authenticate_user!
  before_action :set_up, only: [:show, :edit, :update]

  def show
    @user = User.find(params[:id])
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

  def update
    @user = User.find(params[:id])
    if @user.update_attributes(user_params)
      flash[:success] = "User Updated!"
      render action: :edit
    else
      render action: :edit
    end
  end

  def index
  	@users = User.all
	end

  def set_up
    @user = User.find(params[:id])
    @employments = @user.employments
    @employment = @employments.where(company_id: params[:company]).first
    @leave_requests = @user.leave_requests
    @current_employments = @current_user.employments
    @current_employment = @current_employments.where(company_id: params[:company], acceptance: true).first
  end

  def user_params
		params.require(:user).permit(
			:id,
			:name,
      :email,
      :password,
      :password_confirmation,
      :current_password,
      profile_attributes: [:id,
                        :first_name,
                        :last_name],
      employments_attributes: [:id,
                              :start_date,
                              :end_date,
                              :company_id,
                              :user_id,
															:role_id
															]
		)
	end
end
