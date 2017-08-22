class LeaveRequest < ApplicationRecord
	belongs_to :employment

	validates_presence_of :title, :description
	validate :check_leave_date_and_time
	validates_presence_of :leave_type_id, :employment_id	

	attr_accessor :check_leave_date_and_time
	def check_leave_date_and_time
		correct = true
		if start_date > end_date
			correct = false
			errors.add[:start_date, "can't be later than End Date"]
			errors.add[:end_date, "can't be earlier than End Date"]
		else
			if start_time > end_time
				correct = false
				errors.add(:start_time, "can't be later than End Time")
				errors.add(:end_time, "can't be earlier than End Date")
			end
		end

		return correct
	end	

end