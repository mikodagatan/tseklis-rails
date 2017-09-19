class Employment < ApplicationRecord
	belongs_to :company
	belongs_to :user

	has_many :leave_requests
	has_many :leave_amounts, through: :leave_requests
	has_one :leave_reduction

	accepts_nested_attributes_for :leave_reduction

	attr_accessor :skip_validation

	validates :start_date,
				:user_id,
				:role_id,
				presence: true

	validates :salary, presence: true, numericality: {greater_than: 0 }

	after_commit :new_employment_same_company, on: :update
	after_commit :hr_before, on: :create

	def new_employment_same_company(acceptance: nil)
		if self.acceptance == true
			same_employment = Employment.where(user_id: self.user_id).where(company_id: self.company_id)
			same_employment_count = same_employment.count
			if same_employment_count > 1
			no_end_dates = same_employment.where(end_date: nil)
			no_end_dates
				.where.not(id: self.id)
				.update_all(end_date: Date.today)
			end
		end
	end

	def hr_before
		@hr_officer = Role.find(1)
		if self.user.employments
			.where(role_id: @hr_officer.id)
			.where(company_id: self.company_id)
			.present? &&
			self.role_id != @hr_officer.id
		self.update(role_id: @hr_officer.id)
		end
	end

	def current_employment(user_given, company_given)
		Employment.find_by(user_id: user_given.id, company_id: company_given.id)
	end
end
