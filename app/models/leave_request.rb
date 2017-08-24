class LeaveRequest < ApplicationRecord
	belongs_to :employment

	validates_presence_of :title
	validates_presence_of :description
	validates_presence_of :start_date
	validates_presence_of :end_date
	validates_presence_of :leave_type_id
	validates_presence_of :employment_id

	attr_accessor :monthly_add

	def self.monthly_add
		add = 0
		this_month = Date.today.month
		self.each do |u|
			@start_date = u.start_date
			@end_date = u.end_date
			if @end_date.month > this_month
				@end_date = start_date.end_of_month
			elsif start_date.month < this_month
				@start_date = @end_date.start_of_month
			end
			add += @end_date.day - @start_date.day + 1
		end
		return add
	end

end