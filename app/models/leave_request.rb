class LeaveRequest < ApplicationRecord
	belongs_to :employment
	has_many :leave_amounts, foreign_key: :leave_request_id

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
		weekends_included = self.company.company_leave_setting.include_weekends
		holidays = self.company.holidays
		self.each do |leave_request|
			start_date = leave_request.start_date
			end_date = leave_request.end_date
			start_time = leave_request.start_time
			end_time = leave_request.end_time
			if start_date.year < end_date.year
				duration_date = start_date.days_in_year + end_date.yday - start_date.yday + 1
				# counting days always + 1
			else
				duration_date = end_date.yday - start_date.yday
			end
			date = start_date
			duration_date.times do |date|
				leave_amount = LeaveAmount.new do |att|
					att.date = date
					att.leave_request_id = leave_request.id
					# To see if it's better to add holiday logic after save
					if end_time.hour - start_time.hour + ((end_time.minutes - start_time.minutes).abs) < 4
						att.amount = 0.5
					else
						att.amount = 1
					end
					if date.on_weekend? && weekends_included
						att.amount = 0
					end
				end
				date.advance(days: 1)
			end
		end
	end
end