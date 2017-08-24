class Company < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable

	has_many :employments
	has_many :users, through: :employments
	has_many :leave_requests, through: :employments
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
			value = value_whole_day
			leave << {name => value}
		end
		return leave
	end

	attr_accessor :enter_leaves_taken
	def enter_leaves_taken
		
		leave = []

		self.leave_types.each do |p|
			value = 0
			leave_requests = p.company.leave_requests
				.where(leave_type_id: p.id)
				.where(acceptance: true)
				
				leave_requests.each do |leave_request|
					start_d = leave_request.start_date
					end_d = leave_request.end_date
					start_t = leave_request.start_time
					end_t = leave_request.end_time
					
					if start_d.month < end_d.month || start_d.year < end_d.year
						begin
							unless start_d.on_weekend? || 
								day_add += 1  
							start_d = start_d.advance(days: 1)
						end until end_d == start_d
						# to_add = (leave_request.start_date.end_of_month.day + 1) - leave_request.start_date.day 			

					end

				end
			end 
			name = p.name
			leave << {name => value}
		end
		return leave
	end

end
