class LeaveRequest < ApplicationRecord
	belongs_to :employment
	has_many :leave_amounts, foreign_key: :leave_request_id

	after_commit :enter_amounts

	validates_presence_of :title
	validates_presence_of :description
	validates_presence_of :start_date
	validates_presence_of :end_date
	validates_presence_of :leave_type_id
	validates_presence_of :employment_id

	protected

	attr_accessor :enter_amounts

	def enter_amounts(acceptance = nil)
		if self.acceptance.present?
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
				focus_date = start_date
				duration_date.times do |date|
					leave_amount = LeaveAmount.new do |att|
						att.date = focus_date
						att.leave_request_id = leave.id
						# To see if it's better to add holiday logic after save
						if (focus_date == end_date) && (start_date == end_date) 
							if (end_time - start_time < 1.hours)
								att.amount = 0
							elsif (end_time - start_time < 2.hours)
								att.amount = 0.25
							elsif (end_time - start_time < 4.hours)
								att.amount = 0.5
							end
						else
							att.amount = 1
						end
						if (focus_date.on_weekend? && weekends_included) || (holidays.find_by(date: focus_date).present?)
							att.amount = 0
						end
					end
					leave_amount.save
					focus_date = focus_date.next_day
				end
			end
		end
	end

end