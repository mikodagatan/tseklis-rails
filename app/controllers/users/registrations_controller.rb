class Users::RegistrationsController < Devise::RegistrationsController

	def create
		super

		@user = User.new(user_params)
		@profile = @user.build_profile
	end

	private

	def user_params
		params.require(:user).permit(
							:email, 
							:password, 
							:password_confirmation, 
							profile_attributes: [:id, 
																	 :first_name, 
																	 :last_name])
	end

end