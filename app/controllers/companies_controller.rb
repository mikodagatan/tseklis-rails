class CompaniesController < ApplicationController

	before_action :set_up, only: [ :edit, :update, :show]
	after_action :destroy_leave_type_blank, only: [:update ]

  helper ApplicationHelper

	def index
		@companies = Company.all
	end

	def new
		@user = User.find(current_user.id)
		@company = Company.new
		@employment = @company.employments.build
		@address = @company.build_address
		@company_leave_setting = @company.build_company_leave_setting
	end

	def create
		@user = User.find(current_user.id)
		@company = Company.new(company_params)
		if @company.save
			flash[:success] = "Company Created"
			redirect_to root_path
		else
			render action: :new
		end
	end

	def edit
		1.times do
			leave_type = @leave_types.build
		end
			holiday = Company.find(params[:id]).holidays.build
	end

def update
		if @company.update_attributes(company_params)
	    flash[:success] = "Company Updated!"
	    redirect_to edit_company_url( params[:id] )
	  else
	  	# flash[:failure] = "Error in Update!"
	    render action: :edit
	  end
	end

	def show
		@user = current_user
		@sum = 0
		@leaves = []
		@month_segmented_leaves = @company.segmented_leaves(Date.today.all_month)
		@month_total_leaves = @company.total_leaves(Date.today.all_month)
		@current_employment = @current_company.employments.find_by(user_id: @current_user, company_id: @company)
    @leave_requests = @company.leave_requests.reverse_order
    @leave_requests = Kaminari.paginate_array(@leave_requests).page(params[:page]).per(5)
 	end

	private

	def company_params
	  params.require(:company).permit(
			:id,
			:name,
	  	employments_attributes: [
	  		:id,
  			:start_date,
  			:end_date,
  			:salary,
  			:acceptance,
  			:acceptor_id,
  			:user_id,
  			:company_id,
  			:role_id
  		],
	  	address_attributes: [
	  		:id,
	  		:first_line,
	  		:second_line,
	  		:city_town,
	  		:province,
	  		:country,
	  		:zip_code,
	  		:company_id
	  	],
		  leave_types_attributes: [
		  	:id,
	  		:name,
	  		:company_id,
	  		:amount,
	  		:_destroy
	  	],
		  company_leave_setting_attributes: [
	  		:company_id,
	  		:leave_month_expiration,
	  		:leave_month_start,
	  		:prorate_accrual,
	  		:include_weekends
	  	],
	  	holidays_attributes: [
	  		:id,
	  		:name,
	  		:date,
	  		:company_id
	  	]
	  )
end


def set_up
	@company = Company.find_by_id(params[:id])
	@employments = @company.employments
	@address = @company.address
	@leave_types = @company.leave_types
	@leave_requests = @company.leave_requests
	@company_leave_setting = @company.company_leave_setting
end

def destroy_leave_type_blank
	leave_types = @leave_types
	leave_types.each do |leave_types_array|
		leave_type = leave_types_array
		LeaveType.destroy(leave_type.id) if leave_type[:id].nil? || (leave_type[:amount].nil? || leave_type[:name].blank?)
	end
end

end
