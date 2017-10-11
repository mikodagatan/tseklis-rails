class Employment < ApplicationRecord
	belongs_to :company
	belongs_to :user, required: false

	has_many :leave_requests
	has_many :leave_amounts, through: :leave_requests
	has_many :leave_reductions

	# Add Manager
	has_many :subordinates, class_name: 'Employment',
	                        foreign_key: :manager_id
	belongs_to :manager, class_name: 'Employment', optional: true

	# Email Invitation
	has_many :invitations, :class_name => "Invite", :foreign_key => 'recipient_id'
  has_many :sent_invites, :class_name => "Invite", :foreign_key => 'sender_id'

	accepts_nested_attributes_for :leave_reductions

	validates :start_date,
				:user_id,
				:role_id,
				presence: true


	# validates :salary, presence: true, numericality: {greater_than: 0 }

	after_commit :new_employment_same_company, on: :update
	after_commit :hr_before, on: :create

	ransack_alias :employee_name, :user_profile_first_name_or_user_profile_last_name


	def regularized?
		regularized == true
	end

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
