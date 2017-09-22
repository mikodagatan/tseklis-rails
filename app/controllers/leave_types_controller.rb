class LeaveRequestsController < ApplicationController
  before_action :set_up

  def new
  	@leave_type = @company.leave_types.build
  end

  def create
  	@leave_type = @company.leave_types.build(leave_type_params)
  	if @leave_type.save
  		flash[:success] = "Leave Type Created!"
  		redirect_to user_path( @user.id )
  	else
  		# flash[:alert] = "Cannot create Leave Type!"
  		render action: :new
    end
  end

  def edit
  end

 	def update
 		if @leave_type.update_attributes(leave_type_params)
 			flash[:success] = "#{@leave_type.name} Leave Updated!"
 			redirect_to user_path( @user.id )
 		else
 			# flash[:alert] = "Error in Update!"
 			render action: :edit
    end
 	end

 	def destroy
 	end

  private

	def set_up
		@user = current_user
  	@employments = @user.employments
		@employment = @user.employments.last
		@company = Company.find_by(params[:id])
  	@leave_request = @employment.leave_requests.find_by_id( params[:id] )
	end

	def leave_type_params
		params.require(:leave_type).permit(
					:id,
					:name,
  		    :amount,
          :company_id)
  end

end
