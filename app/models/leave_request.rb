class LeaveRequest < ApplicationRecord
	belongs_to :employment
	has_many :leave_amounts, foreign_key: :leave_id

	after_save :enter_amounts

	validates_presence_of :title
	validates_presence_of :description
	validates_presence_of :start_date
	validates_presence_of :end_date
	validates_presence_of :leave_type_id
	validates_presence_of :employment_id

	protected

	attr_accessor :enter_amounts

	def enter_amounts
		weekends_included = self.employment.company.company_leave_setting.include_weekends
		holidays = self.employment.company.holidays
		leave_request = Array.wrap(self) 
		leave_request.each do |leave|
			start_date = leave.start_date
			end_date = leave.end_date
			start_time = leave.start_time
			end_time = leave.end_time
			if start_date.end_of_year < end_date
				duration_date = start_date.days_in_year.day + end_date - start_date + 1.day
				# counting days always + 1
			else
				duration_date = end_date - start_date + 1
				duration_date = duration_date.to_i
			end
			duration_date.times do |date|
				leave_amount = LeaveAmount.new do |att|
					att.date = start_date
					att.leave_request_id = leave.id
					# To see if it's better to add holiday logic after save
					if (start_date == end_date) &&(end_time - start_time < 4.hours)
						att.amount = 0.5
					else
						att.amount = 1
					end
					if start_date.on_weekend? && weekends_included
						att.amount = 0
					end
				end
				leave_amount.save
				start_date = start_date.next_day
			end
		end
	end

end