class LeaveReduction < ApplicationRecord
  belongs_to :employment
  belongs_to :leave_type
end
