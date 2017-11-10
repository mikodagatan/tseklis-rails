class CompaniesController < ApplicationController

	before_action :restrict_index, only: [:index]
	before_action :set_up, only: [ :edit, :update, :show ]
	after_action :destroy_leave_type_blank, only: [:update ]
	before_action :redirect_not_company, only: [ :edit, :update, :show, :leave_requests_index]

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
		@month_segmented_leaves = @company.segmented_leaves(Time.zone.today.all_month)
		@month_total_leaves = @company.total_leaves(Time.zone.today.all_month)
		@current_employment = Employment.where(user_id: @user, company_id: @company, acceptance: true).first

		# Search
		# @search_employee = User.where('employments.company_id = ?', @company.id).ransack(params[:q])
		# @result_employees = @search_employee.result(distinct: true).includes(:profile, :employments)

		@q_employments = Employment.where(company_id: @company.id).where(acceptance: true).reverse_order.ransack(params[:q_employments])
		@employments = @q_employments.result(distinct: true).page(params[:employments_page]).per(@per_show)

		@year_search = params[:leave_data_year].to_s.to_i
		@year_search = Time.zone.today.strftime('%Y').to_i if @year_search == 0

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
				.where('leave_amounts.date between ? and ?', Time.zone.today.at_beginning_of_month, Time.zone.today.at_end_of_month)
				.where('leave_requests.acceptance = ?', true)
				.references(:leave_amounts)
		elsif params[:month_used].to_s.to_i == 0
			@leave_data = @company.employments.includes(:leave_amounts)
				.where('leave_amounts.date between ? and ?', Date.new(@year_search).at_beginning_of_year, Date.new(@year_search).at_end_of_year)
				.where('leave_requests.acceptance = ?', true)
				.references(:leave_amounts)
		else
			@leave_data = @company.employments.includes(:leave_amounts)
				.where('leave_amounts.date between ? and ?', Date.new(@year_search, params[:month_used].to_s.to_i).at_beginning_of_month, Date.new(@year_search, params[:month_used].to_s.to_i).at_end_of_month)
				.where('leave_requests.acceptance = ?', true)
				.references(:leave_amounts)
		end


		@months = [{Year: 0}, {January: 1}, {February: 2}, {March: 3}, {April: 4}, {May: 5}, {June: 6}, {July: 7}, {August: 8}, {September: 9}, {October: 10}, {November: 11 }, {December: 12 }]

		# manager subordinates
		if user_signed_in? && @current_employment.present?
			@subordinates = @current_employment.subordinates
				.where(end_date: nil, acceptance: true)
			@subordinate_leave_requests = LeaveRequest.where(employment_id: @subordinates.ids).reverse_order
			@subordinate_leave_requests = Kaminari.paginate_array(@subordinate_leave_requests).page(params[:lr_page_manager_dashboard]).per(@per_show)
		end


		respond_to do |format|
	    format.html # index.html.erb
	    format.js # ajax will call this format not html or json
	    # format.json { render json: @portefeuillemodeles }
		end

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
		@current_employment = @company.employments.where(user_id: @current_user, acceptance: true)
	end

	def import_page
		@company = Company.find(params[:company_id])
	end

	def import_leave_requests
		@company = Company.find(params[:company_id])
		LeaveRequest.import(params[:file], @company, @current_user)
		flash[:success] = "Leave Requests Imported"
		redirect_to company_import_page_url(@company)
	end

	def delete_leave_requests
		@company = Company.find(params[:company_id])
		LeaveRequest.mass_delete(params[:file], @company, @current_user)
		flash[:success] = "Delete submitted data."
		redirect_to company_import_page_url(@company)
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
	  			:role_id,
					:regularized
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
		  	],
				departments_attributes: [
					:id,
					:name
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
			.where('leave_amounts.date between ? and ?', Time.zone.today.at_beginning_of_month, Time.zone.today.at_end_of_month)
			.where('leave_requests.acceptance = ?', true)
			.references(:leave_amounts)
	end

	def redirect_not_company
    unless user_signed_in? && current_user.employments.where(company: @company).present?
      redirect_to root_url
    end
  end

	def restrict_index
		authenticate_or_request_with_http_basic('Administration') do |username, password|
		 ActiveSupport::SecurityUtils.secure_compare(username, "admin") &&
		 ActiveSupport::SecurityUtils.secure_compare(password, "!tseklisadministratorpass")
	 end
	end

end
