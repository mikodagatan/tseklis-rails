class ProfilesController < ApplicationController
  
  def new
  	@user = User.find( params[:user_id])
  	@profile = @user.build_profile
  end

  def create
  	@user = User.find( params[:user_id] )
	  @profile = @user.build_profile(profile_params)
  end

end
