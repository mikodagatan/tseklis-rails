class Employment < ApplicationRecord
	belongs_to :company
	belongs_to :user

	has_many :leave_requests

	validates :employment_start_date, presence: true
	validates :employment_end_date, presence: true
	validates :salary, presence: true
	validates :user_id, presence: true
	validates :company_id, presence: true
	validates :role_id, presence: true

end
