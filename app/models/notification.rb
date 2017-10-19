class Notification < ApplicationRecord
  belongs_to :user, required: false
  belongs_to :acting_user, class_name: 'User', required: false
  belongs_to :employment, required: false
  belongs_to :leave_request, required: false

  validates :user_id, :acting_user_id, :employment_id, :notice_type, presence: true


end
