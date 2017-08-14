class CompaniesController < ApplicationController

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
			flash[:alert] = "Company Creation failed"
			render action: :new
		end
	end

	def edit
	end

	private

	def company_params
	  params.require(:company).permit(:name, 
																  	employments_attributes: 
																  			[:start_date,
																  			:end_date,
																  			:salary, 
																  			:user_id, 
																  			:company_id],
																  	address_attributes:
																	  		[:name,
																  			:first_line,
																	  		:second_line,
																	  		:city_town,
																	  		:province,
																	  		:country,
																	  		:zip_code,
																	  		:addresable_type,
																	  		:addressable_id])
	end
end