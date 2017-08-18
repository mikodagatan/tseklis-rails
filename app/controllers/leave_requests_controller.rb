class LeaveRequestsController < ApplicationController
  before_action :set_up


	def new
		@leave_request = @employment.leave_requests.build
	end

	def create
		@leave_request = @employment.leave_requests.build(leave_request_params)
  	if @leave_request.save
	    flash[:success] = "Leave Request Created!"
	    redirect_to user_path( params[:user_id] )
	  else
	  	flash[:alert] = "Cannot create Leave Request!"
	    render action: :new
	  end
	end

	def edit
	end

	def update
		if @leave_request.update_attributes(leave_request_params)
	    flash[:success] = "Employment Updated!"
	    redirect_to user_path( params[:user_id] )
	  else
	  	flash[:alert] = "Error in Update!"
	    render action: :edit
	  end
	end

	private
		def set_up
			@user = current_user
	  	@employments = @user.employments
			@employment = @user.employments.last
	  	@leave_request = @employment.leave_requests.find_by_id( params[:id] )
		end

		def leave_request_params
			params.require(:leave_request).permit(
				:id,
				:title,
				:description,
				:start_date,
				:end_date,
				:leave_type_id,
				:employment_id)
		end

end
