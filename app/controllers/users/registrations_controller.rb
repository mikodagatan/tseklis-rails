class Users::RegistrationsController < Devise::RegistrationsController

	def create
		super
	end

	def edit
		super
		@user = current_user
		@profile = @user.profile
	end

	def update
		super
			
	end

	protected

	def after_update_path_for(resource)
		user_url(current_user)
	end
end