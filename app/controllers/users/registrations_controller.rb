class Users::RegistrationsController < Devise::RegistrationsController

	def new
		@token = params[:invite_token]
		@email = params[:email]
		@start_date = params[:start_date]
		@first_name = params[:first_name]
		@last_name = params[:last_name]
		@salary = params[:salary]
		@user = User.new
		@profile = @user.build_profile
	end

	def create
		@user = User.new(user_params)
		@token = params[:invite_token]
		@start_date = params[:start_date]
		@salary = params[:salary]
		@user.skip_confirmation! if @token.present?
		if @user.save
			if @token.present?
				@invite = Invite.find_by_token(@token)
				org =  @invite.company
				@employment = Employment.new(
												company: org,
												user: @user,
												role_id: @employee.id,
												start_date: @start_date,
												acceptance: true,
												acceptor_id: @invite.sender_id,
												salary: @salary
											)
				if @employment.save
					create_notification_join_company(@employment)
					flash[:success] = "Created Account for " + @user.profile.first_name + " " + @user.profile.last_name + ". Please login with your credentials."
					redirect_to new_user_session_url
				else
					flash[:alert] = show_error_messages(@employment)
					render action: :new
				end
		  else
				flash[:success] = "Created Account for " + @user.profile.first_name + " " + @user.profile.last_name + ". Please wait for your confirmation email."
				redirect_to new_user_session_url
	  	end
		else
			render action: :new
			return
		end

	end

	def edit
		super
		@user = current_user
		@profile = @user.profile
	end

	protected

	def after_update_path_for(resource)
		user_url(current_user)
	end

	def user_params
		params.require(:user).permit(
			:id,
			:name,
      :email,
			:time_zone,
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
															:role_id,
															:salary
															]
		)
	end

	def permit_url_params
		params.permit(
			:invite_token,
			:first_name,
			:last_name,
			:start_date,
			:salary
		)
	end

	def create_notification_join_company(employment)
		@hr_officers = employment.company.employments.where(role_id: 1)
		Array.wrap(@hr_officers).each do |hr_officer|
			Notification.create(
				user_id: hr_officer.user.id,
				acting_user_id: @user.id,
				employment_id: employment.id,
				leave_request_id: nil,
				notice_type: 'join_company',
				read: false)
		end
	end
end
