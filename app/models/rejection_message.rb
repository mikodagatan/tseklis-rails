class RejectionMessage < ApplicationRecord
belongs_to :leave_request

validates :description, presence: true

end
