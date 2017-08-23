class Company < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable

	has_many :employments
	has_many :users, through: :employments
	has_many :leave_requests, through: :employments
	has_one	 :address

	has_one  :company_leave_setting
	has_many :leave_types, dependent: :destroy

	accepts_nested_attributes_for :employments, :address, 
		:leave_types,
		:company_leave_setting, 
		# reject_if: lambda { |a| a[:name].blank? },
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
		 	value_multiple = 
			name = p.name
			value = value_whole_day
			leave << {name => value}
		end
		return leave
	end

end