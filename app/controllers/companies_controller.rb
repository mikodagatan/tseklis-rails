class CompaniesController < ApplicationController

	before_action :set_up, only: [ :edit, :update, :show]

	def index
	end

	def new
		@user = User.find(current_user.id)
		@company = Company.new
		@employment = @company.employments.build
		@address = @company.build_address
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
	end

	def update
		if @company.update_attributes(company_params)
	    flash[:success] = "Company Updated!"
	    redirect_to company_path( params[:user_id] )
	  else
	  	flash[:failure] = "Error in Update!"
	    render action: :edit
	  end
	end

	private

	def company_params
	  params.require(:company).permit(
	  							:name, 
							  	employments_attributes: 
							  			[:id,
							  			:employment_start_date,
							  			:salary,
							  			:user_id, 
							  			:company_id,
							  			:role_id],
							  	address_attributes:
								  		[:id,
								  		:first_line,
								  		:second_line,
								  		:city_town,
								  		:province,
								  		:country,
								  		:zip_code,
								  		:company_id])
	end

	def set_up
		@user = current_user
		@users = User.all
		@company = Company.find_by_id(params[:id])
		@employments = @company.employments
		@address = @company.address
	end

end

