class LeaveType < ApplicationRecord
belongs_to :company
has_many :leave_requests

end
