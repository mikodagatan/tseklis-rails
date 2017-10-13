class Notification < ApplicationRecord
  belongs_to :user
  belongs_to :acting_user, class_name: 'User'
  belongs_to :employment
  belongs_to :leave_request, required: false

  validates :user_id, :acting_user_id, :employment_id, :notice_type, presence: true

  validates :identifier, required: false


end
