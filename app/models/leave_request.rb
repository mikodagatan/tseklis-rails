class LeaveRequest < ApplicationRecord
	belongs_to :employment
	has_many :leave_amounts, foreign_key: :leave_request_id

	validates_presence_of :title
	validates_presence_of :description
	# validates_presence_of :start_date
	# validates_presence_of :end_date
	# validates_presence_of :start_time
	# validates_presence_of :end_time
	validates_presence_of :leave_type_id
	validates_presence_of :employment_id

	validate :check_presence_validity
  validate :check_date_validity
	validate :check_time_validity
  validate :invalidate_weekends_and_holidays_only
	validate :check_leaves_available
	validate :check_regularized
	# after_validation :check_date_taken_validity

	after_commit :enter_amounts




	def show_amount
		amount = []
		focus_date = start_date
		duration_date.times do |date|
			if focus_date == end_date
				if (end_time - start_time <= 1.hours)
					amount_plus = 0
				elsif (end_time - start_time <= 2.hours)
					amount_plus = 0.25
				elsif (end_time - start_time <= 4.hours)
					amount_plus = 0.5
				else
					amount_plus = 1
				end
			else
					amount_plus = 1
			end
			if allow_weekend_holiday_leave == false
				if ((focus_date.on_weekend? && weekends_included?) || on_holiday?(focus_date))
					amount_plus = 0
				end
			end
			amount << amount_plus
			focus_date = focus_date.next_day
		end
		amount.sum
	end

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
		if start_date.nil?
			errors.add(:start_date, "must not be empty")
			condition = false
		elsif end_date.nil?
			errors.add(:end_date, "must not be empty")
			condition = false
   	else allow_weekend_holiday_leave == false
      if duration_date <= 2 && ((on_holiday?(start_date) || on_holiday?(end_date)) || (start_date.on_weekend? || end_date.on_weekend?))
        errors.add(:end_date, ": cannot enter leave solely on a weekend or holiday")
      end
    end
  end

  def check_date_validity
		if start_date.nil?
			errors.add(:start_date, "must not be empty")
			condition = false
		elsif end_date.nil?
			errors.add(:end_date, "must not be empty")
			condition = false
    elsif start_date > end_date
			errors.add(:start_date, "can't be earlier than end date")
			condition = false
    end
  end

	def check_leaves_available
		if check_time_validity && check_date_validity
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

	def check_time_validity
		condition = true
		if start_time.nil?
			errors.add(:start_time, "must not be empty")
			condition = false
		elsif end_time.nil?
			errors.add(:end_time, "must not be empty")
			condition = false
		elsif start_date == end_date && start_time > end_time
			errors.add(:start_time, " can't be earlier than end time on the same date")
			condition = false
		end
	end

	def check_date_taken_validity
		if self.employment.leave_amounts
			.where("leave_amounts.date within ? and ?", start_date, end_date)
			.present?
			errors.add(:start_date, "Cannot contain dates of already submitted leaves requests")
		end
	end

	def check_presence_validity
		condition = true
		if title.nil?
			errors.add(:title, 'must not be empty')
			condition = false
		end
		if description.nil?
			errors.add(:description, 'must not be empty')
			condition = false
		end
		if start_date.nil?
			errors.add(:start_date, 'must not be empty')
			condition = false
		end
		if end_date.nil?
			errors.add(:end_date, 'must not be empty')
			condition = false
		end
		if leave_type_id.nil?
			errors.add(:leave_type_id, 'must not be empty')
			condition = false
		end
		if employment_id.nil?
			errors.add(:employment_id, 'must not be empty')
			condition = false
		end
	end

	def check_regularized
		if leave_type_id.nil?
			errors.add(:leave_type_id, "can't be blank")
		elsif self.leave_type_id != 1 &&
			self.employment.regularized == false &&
			self.employment.company.company_leave_setting.regularized_employees_only == true
			errors.add(:leave_type_id, "can't be used by non-regularized employees")
		end
	end
end
