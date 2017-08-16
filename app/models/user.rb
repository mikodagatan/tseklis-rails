class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

	has_one  :profile
	has_one  :user_role, through: :employments
	has_many :employments
	has_many :companies, through: :employments
	has_many :leave_requests, through: :employments

	accepts_nested_attributes_for :profile, reject_if: :all_blank

	def employed?(company=nil)
		if company == nil
			employments.present?
		else
			companies.include?(company)
		end
	end

	def have_leave_request?(leave_request=nil)
		if leave_request == nil
			leave_requests.present?
		else
			leave_requests.include?(leave_request)
		end
	end

end
