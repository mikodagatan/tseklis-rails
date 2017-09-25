class CompaniesController < ApplicationController

	before_action :set_up, only: [ :edit, :update, :show, ]
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
		@leave_types = @company.leave_types.build
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
		@per_show = 10
		@user = current_user
		@sum = 0
		@leaves = []
		@month_segmented_leaves = @company.segmented_leaves(Date.today.all_month)
		@month_total_leaves = @company.total_leaves(Date.today.all_month)
		@current_employment = @current_company.employments.find_by(user_id: @current_user, company_id: @company) if @current_company.present?

		# Search
		# @search_employee = User.where('employments.company_id = ?', @company.id).ransack(params[:q])
		# @result_employees = @search_employee.result(distinct: true).includes(:profile, :employments)

		@q_employments = Employment.where(company_id: @company.id).where(acceptance: true).reverse_order.ransack(params[:q_employments])
		@employments = @q_employments.result(distinct: true).page(params[:employments_page]).per(@per_show)

		# Kaminari
    @leave_requests = @company.leave_requests.reverse_order
    @leave_requests = Kaminari.paginate_array(@leave_requests).page(params[:leave_requests_page]).per(@per_show)
		# @employments = @company.employments.where('employments.acceptance = true').reverse_order
		# @employments = Kaminari.paginate_array(@employments).page(params[:employments_page]).per(@per_show)
    @has_leave_types = @company.leave_types.present? ? true : false
		@join_requests = @company.employments.where('employments.acceptance IS null').reverse_order
		@join_requests = Kaminari.paginate_array(@join_requests).page(params[:join_requests_page]).per(@per_show)

		# leave_data
		if params[:month_used].nil?
			@leave_data = @company.employments.includes(:leave_amounts)
				.where('leave_amounts.date between ? and ?', Date.today.at_beginning_of_month, Date.today.at_end_of_month)
				.where('leave_requests.acceptance = ?', true)
				.references(:leave_amounts)
		elsif params[:month_used].to_s.to_i == 0
			@leave_data = @company.employments.includes(:leave_amounts)
				.where('leave_amounts.date between ? and ?', Date.today.at_beginning_of_year, Date.today.at_end_of_year)
				.where('leave_requests.acceptance = ?', true)
				.references(:leave_amounts)
		else
			@leave_data = @company.employments.includes(:leave_amounts)
				.where('leave_amounts.date between ? and ?', Date.new(2017, params[:month_used].to_s.to_i).at_beginning_of_month, Date.new(2017, params[:month_used].to_s.to_i).at_end_of_month)
				.where('leave_requests.acceptance = ?', true)
				.references(:leave_amounts)
		end


		@months = [{Year: 0}, {January: 1}, {February: 2}, {March: 3}, {April: 4}, {May: 5}, {June: 6}, {July: 7}, {August: 8}, {September: 9}, {October: 10}, {November: 11 }, {December: 12 }]

 	end

	def month_change
		@date = @date
	end

	def employees_index
		@company = Company.find(params[:company_id])
		@employments = @company.employments
			.joins(user: :profile)
			.order('profiles.last_name')
			# .where(end_date: nil)
	end

	def leave_requests_index
		@company = Company.find(params[:company_id])
		@leave_requests = @company.leave_requests.reverse_order
    @leave_requests = Kaminari.paginate_array(@leave_requests).page(params[:leave_requests_page]).per(50)
		@current_employment = @current_company.employments.find_by(user_id: @current_user, company_id: @company) if @current_company.present?
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
	        :id,
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

	def leave_data
		return @company.employments.includes(:leave_amounts)
			.where('leave_amounts.date between ? and ?', Date.today.at_beginning_of_month, Date.today.at_end_of_month)
			.where('leave_requests.acceptance = ?', true)
			.references(:leave_amounts)
	end

end
