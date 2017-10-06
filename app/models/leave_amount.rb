class LeaveAmount < ApplicationRecord
	belongs_to :leave_request, foreign_key: :leave_request_id
end
