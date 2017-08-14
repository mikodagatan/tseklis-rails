class Users::RegistrationsController < Devise::RegistrationsController

	def create
		super
	end

	def edit
		super
	end

	def update
		super
			
	end

	protected

	def after_update_path_for(resource)
		user_url(current_user)
	end
end