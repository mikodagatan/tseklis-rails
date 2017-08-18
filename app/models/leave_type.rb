class LeaveType < ApplicationRecord
belongs_to :company
has_one		 :leave_type_amount

accepts_nested_attributes_for :leave_type_amount
end
