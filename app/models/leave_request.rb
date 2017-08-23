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



	# def work_days
	# 	return 0 unless starting_at
	# 	days = 0
	# end

	# attr_accessor :insert_leaves_taken
	# def insert_leaves_taken
	# 	leaves_taken = 0
	# 	query_input = []
	# 	query_output = []
	# 	case end_date.year - start_date.year
	# 		when 0
	# 			case  end_date.month - start_date.month
	# 			when 0	


	# 			end
	# 	end
	# end

	# def date_field
	# 	start_date.strftime("%d/%m/%Y") if start_date.present?
	# 	end_date.strftime("%d/%m/%Y") if end_date.present?
	# end

	# def time_field
	# 	start_time.strftime("%I:%M%p") if start_time.present?
	# 	end_time.strftime("%I:%M%p") if end_time.present?
	# end

	# def date_field=(start_date, end_date)
	# 	@start_date_field = Date.parse(start_date).strftime("%Y-%m-%d")
	# 	@end_date_field = Date.parse(end_date).strftime("%Y-%m-%d")
	# end

	# def time_field=(start_time, end_time)
	# 	@start_time_field = Time.parse(start_time).strftime("%H:%M:%S")
	# 	@end_time_field = Time.parse(end_time).strftime("%H:%M:%S")
	# end

	# def convert_to_date_time
	# 	self.start_time = DateTime.parse("#{@start_date_field} #{@start_time_field}")
	# 	self.end_time = DateTime.parse("#{@end_date_field} #{@end_time_field}"
	
end