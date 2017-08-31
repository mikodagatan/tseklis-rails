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

  def all_available_leaves(company)
    leaves = {}
    company.leave_types.each do |leave_type|
      leaves[leave_type.name] = available_leaves(company, leave_type)
    end
    return leaves
  end


  def available_leaves(company, leave_type)
    leave = {}
    leave_settings = company.company_leave_setting
    start = leave_settings.leave_month_start
    leave_start = self.employments
      .where(company_id: company.id)
      .first
      .start_date
      + start.months
    if Date.today > leave_start
      value = 0
    else
      value = leave_add_calculation(company)
    end
    value = leave_add_calculation(company)
    leave[:name] = leave_type.name
    leave[:amount] = value
    return leave
  end

  def leave_type_amounts(company, leave_type)
    company.leave_amounts
      .where("leave_requests.leave_type_id = ?", leave_type.id)
      .where("employments.user_id = ?", self.id)
      .sum(:amount)
  end

  def prorate_accrual_calc(company, leave_type)
    leave_settings = company.company_leave_setting
    start = leave_settings.leave_month_start
    leave_start = self.employments
      .where(company_id: company.id)
      .first
      .start_date
      + start.months
    available = ((Date.today - leave_start) / 12 * assigned_leave_type_amount(company, leave_type)).to_d(2)
    # Change max_available to a company_leve_setting attribute
    max_available = 30
    available = max_available if available > max_available
  end

  def non_prorate_accrual_calc(company)
    # change this
    10
  end

  def leave_add_calculation(company)
    if company.company_leave_setting.prorate_accrual == true
      prorate_accrual_calc(company)
    else
      # TO CHANGE THIS
      prorate_accrual_calc(company)
    end
  end

  def leave_expire(company, leave_type)
    leave_settings = company.company_leave_setting
    expiration = leave_settings.leave_month_expiration
    start = leave_settings.leave_month_start
    leave_start = self.employments
      .where(company_id: company.id)
      .first
      .start_date
      + start.months
    expiration_start = leave_start + expiration.months
    duration = Date.today - leave_start
    to_expire = 0
    if duration > 0
      added_expiration = ((Date.today - expiration_start / 12) * assigned_leave_type_amount).to_d(2)
      added_expiration.times each do |expiration|
        if leave_add_calculation(company) - leave_type_amounts(copmany, leave_type) - to_expire > expiration
        end
      end
    else
      expired = 0
    end
    return to_expire
  end

  def assigned_leave_type_amount(company, leave_type)
    company.leave_types.find(leave_type.id)
      .where("leave_requests.leave_type_id = ?", leave_type.id)
      .where("employments.user_id = ?", self.id)
      .amount
  end
end
