class Company < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable

	has_many :employments
	has_many :users, through: :employments
	has_many :leave_requests, through: :employments
	has_many :holidays
	has_one	 :address

	has_one  :company_leave_setting
	has_many :leave_types, dependent: :destroy

	accepts_nested_attributes_for :employments, 
		:address, 
		:leave_types,
		:company_leave_setting, 
		:holidays,
		allow_destroy: true

	validates :name, presence: true, uniqueness: true

end
