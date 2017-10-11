class Users::RegistrationsController < Devise::RegistrationsController

	def new
		@token = params[:invite_token]
		@email = params[:email]
		@start_date = params[:start_date]
		@first_name = params[:first_name]
		@last_name = params[:last_name]
		@user = User.new
		@profile = @user.build_profile
	end

	def create
		@user = User.new(user_params)
		@token = params[:invite_token]
		@start_date = params[:start_date]
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
												acceptor_id: @invite.sender_id
											)
				if @employment.save
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

	def permit_url_params
		params.permit(
			:invite_token,
			:first_name,
			:last_name,
			:start_date
		)
	end
end
