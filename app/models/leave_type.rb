class LeaveType < ApplicationRecord
belongs_to :company
has_one		 :leave_type_amount
end
