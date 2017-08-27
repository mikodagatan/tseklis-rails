class Holiday < ApplicationRecord
	belongs_to :company
	has_many :employments
	has_many :users, through: :employments

	after_save :holiday_check

	validates :name, 
		length: { minimum: 3, maximum: 20}
	validates :date, uniqueness: { message: "already has a Holiday."}

	attr_accessor :holiday_check

	def holiday_check
		concurrent = self.company.leave_amounts.where(date: self.date)
		if concurrent.nil?
		else
			concurrent.update_all(amount: 0)
		end
	end

end