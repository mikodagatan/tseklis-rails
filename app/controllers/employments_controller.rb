class EmploymentsController < ApplicationController
	before_action :authenticate_user!
  # before_action :only_current_user
  before_action :set_user_and_employment, only: [:edit, :update]

  def new
    @user = User.find(params[:user_id])
  	@employment = @user.employments.build
  end

  def create
    @user = User.find(params[:user_id])
  	@employment = @user.employments.build(employment_params)
  	if @employment.save
	    flash[:success] = "Employment Created!"
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
  end

  private

  def set_user_and_employment
  	@user = User.find(params[:user_id])
  	@employments = @user.employments
    @employment = @user.employments.find_by_id( params[:id] )
    @current_employment = @current_employments.find_by( company_id: @employment.company_id )
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
            :role_id)
  end

  # def only_current_user
  #   @user = User.find( params[:user_id] )
  #   redirect_to(root_url) unless @user == current_user
  # end

end
