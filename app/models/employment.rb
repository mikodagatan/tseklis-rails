class Employment < ApplicationRecord
	belongs_to :company
	belongs_to :user

	has_many :leave_requests

	validates :start_date, 
				:presence => true 
				#{ message: "Please enter the start date of your employment." }
	validates :end_date, 
				:presence => true #{ message: "Please enter the employee's end date of the employment." }
	validates :salary, 
				:presence => true # { message: "To fully use this website, you will need to share your salary." }
	validates :user_id, 
				:presence => true # { message: "No User ID entered"}
	validates :company_id, 
				:presence => true #{ message: "No Company ID entered" }
	validates :role_id, 
				:presence => true #{ message: "No Role ID entered" }

end
