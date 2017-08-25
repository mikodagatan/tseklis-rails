class LeaveAmount < ApplicationRecord
	belongs_to :leave_request, foreign_key: :leave_request_id
	has_one :leave_type, through: :leave_request
end
