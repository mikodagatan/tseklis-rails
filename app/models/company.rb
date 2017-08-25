class Company < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable

	has_many :employments
	has_many :users, through: :employments
	has_many :leave_requests, through: :employments
	has_many :leave_amounts, through: :leave_requests
	has_many :holidays
	has_one	 :address

	has_one  :company_leave_setting
	has_many :leave_types, dependent: :destroy

	accepts_nested_attributes_for :employments, 
		:address, 
		:leave_types,
		:company_leave_setting, 
		:holidays,
		allow_destroy: true

	validates :name, presence: true, uniqueness: true


	attr_accessor :company_leave_counts
	def company_leave_counts
		leave = []
		self.leave_types.each do |p|
		 	value_whole_day = p.company.leave_requests
		 		.where(leave_type_id: p.id)
		 		.where(acceptance: true)
		 		.where(" EXTRACT(YEAR FROM leave_requests.start_date) = ?", 
		 			Date.today.year)
		 		.where("EXTRACT(MONTH FROM leave_requests.start_date) = ?", 
		 			Date.today.month).where("EXTRACT(HOUR FROM leave_requests.end_time) 
		 			- EXTRACT(HOUR FROM leave_requests.start_time) 
		 			> EXTRACT(HOUR FROM INTERVAL '4 hours')"
		 			).count
		 	value_half_day = p.company.leave_requests
		 		.where(leave_type_id: p.id)
		 		.where(acceptance: true)
		 		.where(" EXTRACT(YEAR FROM leave_requests.start_date) = ?", 
		 			Date.today.year)
		 		.where("EXTRACT(MONTH FROM leave_requests.start_date) = ?", 
		 			Date.today.month)
		 		.where("EXTRACT(HOUR FROM leave_requests.end_time) - EXTRACT(HOUR FROM leave_requests.start_time) 
		 			<= EXTRACT(HOUR FROM INTERVAL '4 hours')"
		 			).count * 0.5
		 	value_multiple = p.company.leave_requests
		 		.where(leave_type_id: p.id)
		 		.where(acceptance: true)
		 		.where("EXTRACT(")
			name = p.name
			value = value_whole_day + value_half_day
			leave << {name => value}
		end
		return leave
	end

	# attr_accessor :enter_leaves_taken
	# def enter_leaves_taken
		
	# 	leave = []

	# 	self.leave_types.each do |p|
	# 		value = 0
	# 		leave_requests = p.company.leave_requests
	# 			.where(leave_type_id: p.id)
	# 			.where(acceptance: true)
				
	# 			leave_requests.each do |leave_request|
	# 				start_d = leave_request.start_date
	# 				end_d = leave_request.end_date
	# 				start_t = leave_request.start_time
	# 				end_t = leave_request.end_time
	# 				month_holidays = leave_request.company.holidays.where(:date.month == start_d.month)
					
	# 				if start_d.month < end_d.month || start_d.year < end_d.year
	# 					begin
	# 						if start_d.on_weekend?
	# 						elsif month_holidays.present?
	# 							month_holidays.each do |month_holiday|
	# 								if start_d == month_holiday
	# 								else
	# 									day_add += 1
	# 								end
	# 							end
	# 						else
	# 							day_add += 1
	# 						end  
	# 						start_d = start_d.advance(days: 1)
	# 					end until (end_d == start_d) || 

	# 				end

	# 			end
	# 		value = day_add 
	# 		name = p.name
	# 		leave << {name => value}
	# 	end
	# 	return leave
	# end


	# attr_accessor :company_leave_counts2
	# def company_leave_counts2
	# 	leave = []
	# 	this_year = Date.today.year
	# 	this_month = Date.today.month
	# 	self.leave_types.each do |leave_type|
	# 		amount = 0
	# 	 	year_values = leave_type.company.leave_requests
	# 	 		.where(leave_type_id: leave_type.id)
	# 	 		.where(acceptance: true)
	# 	 		.where(
	# 	 			"(extract(year from leave_requests.start_date) = ? or extract(year from leave_requests.end_date) = ?)
	# 	 			and (extract(day from leave_requests.start_date) NOT extract(day from leave_requests.end_date))", 
	# 	 			Date.today.year, Date.today.year).count
	# 	 		# monthly iteration
	# 	 		month_values = year_values.where(
	# 	 			"(extract_month from year_values")
	# 	 		year_values.each do |year_val|
	# 	 			start_date = year_val.start_date
	# 	 			end_date = year_val.end_date
	# 	 			if end_date.month > this_month
	# 					end_date = start_date.end_of_month
	# 				elsif start_date.month < this_month
	# 					start_date = end_date.start_of_month
	# 				end
	# 				end_date.day- 
	# 	 		end
	# 	 	name = leave_type.name
	# 		value = year_values
	# 		leave << {name => value}
	# 	end
	# 	return leave
	# end

	attr_accessor :monthly_total

	def self.monthly_total
		minus = 0
		add = 0
		
		this_month = Date.today.month
		month_leaves_by_start = self.leave_requests.where("extract(month from leave_requests.start_date) = ?", this_month)
		month_leaves_by_end = self.leave_requests.where("extract(month from leave_requests.end_date) = ?", this_month )

		total_add = (month_leaves_by_start.monthly_add + month_leaves_by_end.monthly_add)
		total_minus = (month_leaves_by_start.monthly_minus 
			+ month_leaves_by_end.monthly_minus)

		total_monthly = total_add - total_minus

		return total_monthly
	end

	attr_accessor :monthly_minus

	def self.monthly_minus
		minus = 0
		this_month = Date.today.month
		self.each do |u|
			start_date = u.start_date
			end_date = u.end_date
			month_holidays = u.company.holidays.where("extract(month from holidays.date) = ?", this_month)
			month_holidays.each do |t|
				if end_date.month > this_month
					end_date = start_date.end_of_month
				elsif start_date.month < this_month
					start_date = end_date.start_of_month
				end
				if (start_date <= t && t <= end_date) || u.on_weekend? 
					minus += 1
				end

			end
		return minus
		end
	end

	attr_accessor :monthly_add

	def self.monthly_add
		add = 0
		this_month = Date.today.month
		self.each do |u|
			start_date = u.start_date
			end_date = u.end_date
			if end_date.month > this_month
				end_date = start_date.end_of_month
			elsif start_date.month < this_month
				start_date = end_date.start_of_month
			end
			add += end_date.day - start_date.day + 1
		end
		return add
	end

end
