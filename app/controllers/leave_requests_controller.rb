class LeaveRequestsController < ApplicationController
  before_action :set_up

  def index
  end

	def new
    @user = current_user
    @companies_accepted = @company
    @employment = Employment.find(params[:employment_id])
		@leave_request = @employment.leave_requests.build
	end

	def create

		@leave_request = @employment.leave_requests.build(leave_request_params)
  	if @leave_request.save
	    flash[:success] = "Leave Request Created!"
	    redirect_to company_path( @employment.company_id )
	  else
	  	# flash[:alert] = "Cannot create Leave Request!"
	    render action: :new
	  end
	end

	def edit
    if @employment.regularized?
      @available_leave_types = @company.leave_types
    else
      @available_leave_types = @company.leave_types.where(name: 'Unpaid')
      if @available_leave_types.blank?
        @available_leave_types = @company.leave_types.where(name: 'Non-paid')
      end
    end
	end

	def update
		if @leave_request.update_attributes(leave_request_params)
	    flash[:success] = "Leave Request Updated!"
	    if @leave_request.acceptance == true || @leave_request.acceptance == false
        # respond_to do |format|
        #   format.html { redirect_to company_url(@company.id) + "#leave_requests" }
        #   format.js
        # end
	    	redirect_to company_url(@company.id) + "#leave_requests"
	    else
	    	redirect_to user_path( params[:user_id] )
	    end
	  else
	  	# flash[:alert] = "Error in Update!"
	    render action: :edit
	  end
	end

	def show
    @leave_request = LeaveRequest.find(params[:id])
    @employment = @leave_request.employment
	end

  def leave_request_by_hr
    @company_employment
    @companies_accepted = @company
		@leave_request = @employment.leave_requests.build
  end

  def destroy
	  @leave_request = LeaveRequest.find(params[:id])
		if @leave_request.delete
			redirect_to company_url(@company)
      flash[:success] = "Leave Request Deleted!"
      @leave_request.delete_amounts
		else
			render action: :edit
		end
  end

	private
		def set_up
			@user = User.find(params[:user_id])
	  	@employments = @user.employments
			@employment = @user.employments.find(params[:employment_id])
			@company = @employment.company
      @companies = @user.companies
	  	@leave_request = @employment.leave_requests.find_by_id( params[:id] )
	  	@leave_types = @company.leave_types
      if @employment.regularized?
        @available_leave_types = @company.leave_types
      else
        @available_leave_types = @company.leave_types.where(name: 'Unpaid')
        if @available_leave_types.blank?
          @available_leave_types = @company.leave_types.where(name: 'Non-paid')
        end
      end
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
				:allow_weekend_holiday_leave,
				:leave_type_id,
				:employment_id)
		end


end
