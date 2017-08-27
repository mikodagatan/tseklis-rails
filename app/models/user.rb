class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

	has_one  :profile
	has_many :role, through: :employments
	has_many :employments
	has_many :companies, through: :employments
	has_many :leave_requests, through: :employments
	has_many :leave_types, through: :companies
	has_many :leave_amounts, through: :leave_requests

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

	def segmented_leaves(date_used, company)
		leave = []
		self.leave_types.each do |p|
		 	value = company.leave_amounts
		 		.where(date: date_used)
		 		.where(leave_request_id: self.leave_requests.ids)
		 		.where("leave_requests.acceptance = true")
		 		.where("leave_requests.leave_type_id = ?", p.id)
		 		.where("employments.company_id = ?", company.id)
		 		.where("employments.user_id = ?",  self.id)
		 		.sum(:amount)
		 	name = p.name
			leave << {name => value}
		end
		return leave
	end

	def total_leaves(date_used, company)
		self.leave_amounts.where(date: date_used).where("employments.company_id = ?", company.id).sum(:amount)
	end

end
