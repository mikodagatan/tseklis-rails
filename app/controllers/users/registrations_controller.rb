class Users::RegistrationsController < Devise::RegistrationsController

	def new
		super
		@token = params[:invite_token]
		@email = params[:email]
		@start_date = params[:start_date]
		@first_name = params[:first_name]
		@last_name = params[:last_name]
	end

	def create
		super
		@token = params[:invite_token]
		if @token != nil
			org =  Invite.find_by_token(@token).company #find the user group attached to the invite
			@newUser.employment.company_id(org.id) #add this user to the new user group as a member
	  else
	    # do normal registration things #
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
end
