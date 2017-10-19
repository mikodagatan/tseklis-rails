class EmploymentsController < ApplicationController
	before_action :authenticate_user!
  # before_action :only_current_user
  before_action :set_user_and_employment, only: [:edit, :update]

  def new
		if @current_companies.present?
			@available_companies = Company.where('id != ?', @current_companies.ids) || Company.all
		else
			@available_companies = Company.all
		end
		@user = User.find(params[:user_id])
  	@employment = @user.employments.build
  end

  def create
    @user = User.find(params[:user_id])
  	@employment = @user.employments.build(employment_params)
  	if @employment.save
			create_notification_join_accepted(@employment)
	    flash[:success] = "Employment Created!"
	    redirect_to user_path( params[:user_id] )
	  else
	  	# flash[:failure] = "Error in Update!"
	    render action: :new
	  end
  end

	def edit
		@current_role_id = @current_employment.role_id
		@employment.company.leave_types.each do |leave_type|
			@employment.leave_reductions.build(leave_type_id: leave_type.id)
		end
	end

	def update
		if @employment.update_attributes(employment_params)
	    flash[:success] = "Employment Updated!"
      if :in_company
        redirect_to company_url( @employment.company.id )
      else
	      redirect_to user_path( params[:user_id] )
      end
  	else
	  	# flash[:failure] = "Error in Update!"
	    render action: :edit
	  end
	end

  def show
		@current_employment = @current_user.employments.where( company_id: @employment.company_id ).first
  end

	def leave_request_by_hr

	end

  private

  def set_user_and_employment
  	@user = User.find(params[:user_id])
  	@employments = @user.employments
    @employment = @user.employments.find_by_id( params[:id] )
    @current_employment = @current_user.employments.where( company_id: @employment.company_id ).first
  end

  def employment_params
  	params.require(:employment).permit(
            :id,
            :start_date,
            :end_date,
            :salary,
            :acceptance,
            :acceptor_id,
            :company_id,
            :user_id,
            :role_id,
						:regularized,
						:manager_id,
						leave_reductions_attributes: [
							:amount,
							:date,
							:leave_type_id,
							:employment_id
							]
						)
  end

	def create_notification_join_company(employment)
		@hr_officers = employment.company.employments.where(role_id: 1)
		Array.wrap(@hr_officers).each do |hr_officer|
			Notification.create(
				user_id: hr_officer.user.id,
				acting_user_id: @current_user.id,
				employment_id: employment.id,
				leave_request_id: nil,
				notice_type: 'join_company',
				read: false)
		end
	end

  # def only_current_user
  #   @user = User.find( params[:user_id] )
  #   redirect_to(root_url) unless @user == current_user
  # end

end
