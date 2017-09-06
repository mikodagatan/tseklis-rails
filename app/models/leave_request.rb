class LeaveRequest < ApplicationRecord
	belongs_to :employment
	has_many :leave_amounts, foreign_key: :leave_request_id

  validate :check_date_validity
  validate :invalidate_weekends_and_holidays_only
	validate :check_leaves_available
	after_commit :enter_amounts

	validates_presence_of :title
	validates_presence_of :description
	validates_presence_of :start_date
	validates_presence_of :end_date
	validates_presence_of :leave_type_id
	validates_presence_of :employment_id

	protected

	def weekends_included?
		weekends_included = self.employment.company.company_leave_setting.include_weekends
	end

	def on_holiday?(focus_date = nil)
		holidays = self.employment.company.holidays
		holidays.find_by(date: focus_date).present?
	end

	def duration_date
		# counting days always + 1
		duration_date = end_date - start_date + 1
		duration_date = duration_date.to_i
		return duration_date
	end

	def enter_amounts(acceptance = nil)
		amount = []
		focus_date = start_date
		duration_date.times do |date|
			leave_amount = LeaveAmount.new do |att|
				att.date = focus_date
				att.leave_request_id = id
				if focus_date == end_date
					if (end_time - start_time <= 1.hours)
						att.amount = 0
					elsif (end_time - start_time <= 2.hours)
						att.amount = 0.25
					elsif (end_time - start_time <= 4.hours)
						att.amount = 0.5
          else
            att.amount = 1
					end
				else
					att.amount = 1
				end
        if allow_weekend_holiday_leave == false
  				if ((focus_date.on_weekend? && weekends_included?) || on_holiday?(focus_date))
  					att.amount = 0
  				end
        end
			end
			amount << leave_amount.amount
			leave_amount.save if self.acceptance.present?
			focus_date = focus_date.next_day
		end
		amount.sum
	end

  def invalidate_weekends_and_holidays_only
    if allow_weekend_holiday_leave == false
      if duration_date <= 2
        if (start_date.on_weekend? && weekends_included? || on_holiday?(start_date)) && (end_date.on_weekend? && weekends_included? || on_holiday?(end_date))
          errors.add(:end_date, ": cannot enter leave solely on a weekend or holiday")
        end
      end
    end
  end

  def check_date_validity
    if start_date > end_date
      errors.add(:start_date, "cannot be earlier than End date")
    end
  end

	def check_leaves_available
    if self.acceptance.nil?
  		user = self.employment.user
  		company = self.employment.company
  		leave_type = LeaveType.find(self.leave_type_id)
  		available = user.available_leaves(company, leave_type)
  		if enter_amounts > available[:amount]
  			errors.add(:start_date, "You have #{available[:amount]} available leaves but consuming  #{enter_amounts} leaves for #{available[:name]}")
  		end
    end
	end

end
