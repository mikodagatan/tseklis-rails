class LeaveRequestsController < ApplicationController
  before_action :set_up

  def index
  end
  
	def new
		@leave_request = @employment.leave_requests.build
	end

	def create
		@leave_request = @employment.leave_requests.build(leave_request_params)
  	if @leave_request.save
	    flash[:success] = "Leave Request Created!"
	    redirect_to user_path( params[:user_id] )
	  else
	  	# flash[:alert] = "Cannot create Leave Request!"
	    render action: :new
	  end
	end

	def edit
	end

	def update
		if @leave_request.update_attributes(leave_request_params)
	    flash[:success] = "Employment Updated!"
	    if :at_company
	    	redirect_to company_path(@employment.company)
	    else
	    	redirect_to user_path( params[:user_id] )
	    end
	  else
	  	# flash[:alert] = "Error in Update!"
	    render action: :edit
	  end
	end

	def show

	end

	private
		def set_up
			@user = User.find(params[:user_id])
	  	@employments = @user.employments
			@employment = @user.employments.find(params[:employment_id])
			@company = @employment.company
	  	@leave_request = @employment.leave_requests.find_by_id( params[:id] )
	  	@leave_types = @company.leave_types
		end

		def leave_request_params
			params.require(:leave_request).permit(
				:id,
				:title,
				:description,
				:start_date,
				:start_time,
				:end_date,
				:end_time,
				:acceptance,
				:acceptor_id,
				:reviewed,
				:leave_type_id,
				:employment_id)
		end


end
