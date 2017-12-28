class AddLeafe < ApplicationRecord
  belongs_to :employment, required: false
  belongs_to :leave_type, required: false

end
