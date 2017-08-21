class Employment < ApplicationRecord
	belongs_to :company
	belongs_to :user

	has_many :leave_requests

	attr_accessor :skip_validation

	validates :start_date,
				:user_id, 
				:role_id,
				presence: true 

	validates :salary, presence: true,numericality: {greater_than: 0 }
end
