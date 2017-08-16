class Employment < ApplicationRecord
	belongs_to :company
	belongs_to :user

	has_many :leave_requests

end
