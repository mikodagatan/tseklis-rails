class Employment < ApplicationRecord
	belongs_to :company
	belongs_to :user

	has_many :leave_requests

	attr_accessor :skip_validation

	validates :start_date, 
				:salary, 
				:user_id, 
				:role_id,
				presence: true 
	validates :end_date, 
				:company_id, 
				presence: true, 
				unless: :skip_validation
end
