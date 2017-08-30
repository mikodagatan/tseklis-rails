class LeaveRequest < ApplicationRecord
	belongs_to :employment
	has_many :leave_amounts, foreign_key: :leave_request_id

	validate :check_leaves_available
	after_commit :enter_amounts

	validates_presence_of :title
	validates_presence_of :description
	validates_presence_of :start_date
	validates_presence_of :end_date
	validates_presence_of :leave_type_id
	validates_presence_of :employment_id

	protected

	attr_accessor :enter_amounts

	def weekends_included?
		weekends_included = self.employment.company.company_leave_setting.include_weekends
	end

	def on_holiday?(focus_date = nil)
		holidays = self.employment.company.holidays
		holidays.find_by(date: focus_date).present?
	end

	def duration_date
		if start_date.end_of_year < end_date
			duration_date = start_date.days_in_year.day + end_date - start_date + 1.day
			# counting days always + 1
		else
			duration_date = end_date - start_date + 1
			duration_date = duration_date.to_i
		end
		return duration_date
	end

	def enter_amounts(acceptance = nil)
		amount = []
		focus_date = start_date
		duration_date.times do |date|
			leave_amount = LeaveAmount.new do |att|
				att.date = focus_date
				att.leave_request_id = id
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
				if (focus_date.on_weekend? && weekends_included?) || on_holiday?(focus_date)
					att.amount = 0
				end
			end
			amount << leave_amount.amount
			leave_amount.save if self.acceptance.present?
			focus_date = focus_date.next_day
		end
		amount.sum
	end

	def check_leaves_available(leave_type)
		if enter_amounts >
			errors.add(:start_date, "You have 0 available leaves but consuming  #{enter_amounts} leaves")
		else
			errors.add(:start_date, enter_amounts)
		end
	end

end
