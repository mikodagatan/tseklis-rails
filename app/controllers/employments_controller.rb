class EmploymentsController < ApplicationController
	before_action :authenticate_user!
  # before_action :only_current_user
  before_action :set_user_and_employment, only: [:edit, :update]

  def new
    @user = User.find(params[:user_id])
    @employment = @user.employments.find_by_id( params[:employment_id] )
  	@employment = @user.employments.build
  end

  def create
  	@employment = @user.employments.build(employment_params)
  	if @employment.save
	    flash[:success] = "Employment Updated!"
	    redirect_to user_path( params[:user_id] )
	  else
	  	# flash[:failure] = "Error in Update!"
	    render action: :new
	  end
  end

	def edit
	end

	def update
		if @employment.update_attributes(employment_params)
	    flash[:success] = "Employment Updated!"
	    redirect_to user_path( params[:user_id] )
	  else
	  	# flash[:failure] = "Error in Update!"
	    render action: :edit
	  end
	end

  private

  def set_user_and_employment
  	@user = User.find(params[:id])
  	@employments = @user.employments
    @employment = @user.employments.find_by_id( params[:id] )
    # @hr_officer = Role.find(1)
    # @employee = Role.find(2)
    # @administrator = Role.find(653555391)
  end

  def employment_params
  	params.require(:employment).permit(
            :id,
            :start_date, 
            :end_date, 
            :salary, 
            :company_id, 
            :user_id, 
            :role_id)
  end

  # def only_current_user
  #   @user = User.find( params[:user_id] )
  #   redirect_to(root_url) unless @user == current_user
  # end

end