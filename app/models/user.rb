class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :confirmable

	has_one  :profile
	has_many :role, through: :employments
	has_many :employments
	has_many :companies, through: :employments
	has_many :leave_requests, through: :employments
	has_many :leave_types, through: :companies
	has_many :leave_amounts, through: :leave_requests

	accepts_nested_attributes_for :profile, reject_if: :all_blank

  ransack_alias :employee_name, :profile_first_name_or_profile_last_name

	def employed?(company=nil)
		if company.nil?
			employments.present?
		else
			employments.find_by(company_id: company.id).acceptance == true
		end
	end

	def have_leave_request?(leave_request=nil)
		if leave_request == nil
			leave_requests.present?
		else
			leave_requests.include?(leave_request)
		end
	end

  def all_segmented_leaves(date_used, company)
    leaves = {}
    company.leave_types.each do |leave_type|
      leaves[leave_type.name] = segmented_leaves(date_used, company, leave_type)
    end
    return leaves
  end

	def segmented_leaves(date_used, company, leave_type)
		leave = {}
    value = 0
    employment = self.employments
      .where(company_id: company.id)
    employment.each do |emp|
      value += emp
        .leave_amounts
		 		.where(date: date_used)
		 		.where(leave_request_id: self.leave_requests.ids)
		 		.where("leave_requests.acceptance = true")
		 		.where("leave_requests.leave_type_id = ?", leave_type.id)
		 		.sum(:amount)
    end
	 	leave[:name] = leave_type.name
		leave[:amount] = value
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
    # You may want to think that if the expiration is not > 12 months, we will not reach the maximum leave amounts.
    leave = {}
    leave_settings = company.company_leave_setting
    expiration = leave_settings.leave_month_expiration
    start = leave_settings.leave_month_start
    start_d = self.employments
      .where(company_id: company.id)
      .first
      .start_date
    leave_end = self.employments
      .where(company_id: company.id)
      .last
    moving_date = Date.today - expiration.months
    leave_start = start_d + start.months
    if Date.today > leave_start
      value = (leave_add_calculation(company, leave_type) - leave_expire(company, leave_type)).round(2) - segmented_leaves(moving_date..Date.today.years_since(5), company, leave_type)[:amount]
    else
      value = 0.0
    end
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
    leave_end = self.employments
      .where(company_id: company.id)
      .last
      .end_date
    leave_expire = company.company_leave_setting.leave_month_expiration
    leave_start_with_expiration = leave_start + leave_expire.months
    leave_amount_max = (leave_settings.leave_month_expiration / 12 * assigned_leave_type_amount(company,leave_type).to_f)
    if leave_start_with_expiration > Date.today
      if leave_end.present?
        ending = leave_end
      else
        ending = Date.today.at_beginning_of_month
      end
      available = ((ending - leave_start) / Time.days_in_year * assigned_leave_type_amount(company, leave_type))
    else

      # at_beginning_of_month makes this monthly accrual
      available = (Date.today.at_beginning_of_month - leave_start)/ Time.days_in_year * assigned_leave_type_amount(company, leave_type).to_f
    end
    if available > leave_amount_max
      available = leave_amount_max
    end
    return available
  end

  def non_prorate_accrual_calc(company, leave_type)
    leave_settings = company.company_leave_setting
    start = leave_settings.leave_month_start
    leave_start = self.employments
      .where(company_id: company.id)
      .first
      .start_date
      + start.months
    available = ((Date.today - leave_start) / Time.days_in_year * assigned_leave_type_amount(company, leave_type)).to_f
  end

  def leave_add_calculation(company, leave_type)
    if company.company_leave_setting.prorate_accrual == true
      prorate_accrual_calc(company, leave_type)
    else
      # non_prorate_accrual_calc(company, leave_type)
      prorate_accrual_calc(company, leave_type)
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
    leave_end = self.employments
      .where(company_id: company.id)
      .last
      .end_date
    expiration_start = leave_start + expiration.months
    if expiration_start > Date.today
      if leave_end.present?
        ending = leave_end
      else
        ending = Date.today
      end
      expire = ((ending.at_beginning_of_month - expiration_start) / Time.days_in_year * assigned_leave_type_amount(company, leave_type)).to_f
    else
      expire = 0
    end
    return expire
  end

  def assigned_leave_type_amount(company, leave_type)
    company.leave_types.find(leave_type.id)
      .amount
  end

  def leave_reduction(company, leave_type)
    leave_settings = company.company_leave_setting
    expiration = leave_settings.leave_month_expiration
    leave_reduction = self.employments
      .where(company_id: company.id)
      .first
      .leave_reductions
      .where(leave_type_id: leave_type.id)
    if Date.today - (leave_reduction.date + expiration.months) < 0
      return leave_reduction.amount
    else
      return 0
    end
  end
end
