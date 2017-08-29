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
		company.leave_types.each do |p|
      employment = self.employments
        .where(company_id: company)
      value = 0
      employment.each do |emp|
        value += emp
          .leave_amounts
  		 		.where(date: date_used)
  		 		.where(leave_request_id: self.leave_requests.ids)
  		 		.where("leave_requests.acceptance = true")
  		 		.where("leave_requests.leave_type_id = ?", p.id)
  		 		.sum(:amount)
      end
		 	name = p.name
			leave << {name => value}
		end
		return leave
	end

  def total_leaves(date_used, company)
    self.leave_amounts.where(date: date_used).where("employments.company_id = ?", company.id).sum(:amount)
  end

  attr_accessor :available_leaves
  def available_leaves(company)
    leave = []
    leave_settings = company.company_leave_setting
    start = leave_settings.leave_month_start
    leave_start = self.employments
      .where(company_id: company.id)
      .first
      .start_date
      + start.month
    company.leave_types.each do |leave_type|
      if Date.today > leave_start
        value = 0
        with_accrual = ((Date.today - leave_start) / 12).to_i.round(2)
        # add without_accrual
        if leave_settings.prorate_accrual == true
          value = with_accrual
        else
          # Change to without_accrual
          value = with_accrual
        end
        value = 0
      end
      name = leave_type.name
      leave << {name => value}
    end
    return leave
  end


end
