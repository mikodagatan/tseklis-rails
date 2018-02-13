class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :confirmable

	has_one  :profile, dependent: :destroy
  has_one :user_import_password, dependent: :destroy
	has_many :role, through: :employments
	has_many :employments, dependent: :destroy
	has_many :companies, through: :employments
	has_many :leave_requests, through: :employments
	has_many :leave_types, through: :companies
	has_many :leave_amounts, through: :leave_requests
  has_many :notifications, dependent: :destroy

	accepts_nested_attributes_for :profile, reject_if: :all_blank
  accepts_nested_attributes_for :employments

  ransack_alias :employee_name, :profile_first_name_or_profile_last_name

  def full_name
    "#{profile.first_name} #{profile.last_name}"
  end
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


  def available_leaves(company, leave_type, date = nil)
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
      .end_date
    if date.present?
      moving_date = date - expiration.months
      moving_date_end = date
    else
      moving_date = Time.zone.today - expiration.months
      moving_date_end = Time.zone.today
    end

    leave_start = start_d + start.months
    leave_amount_max = (leave_settings.leave_month_expiration / 12 * assigned_leave_type_amount(company,leave_type).to_f)
    add_leaves = self.employments
      .where(company_id: company.id)
      .last
      .add_leaves
      .where(leave_type_id: leave_type.id)
      .sum(:amount)
    place1 = leave_add_calculation(company, leave_type, date).round(2)
    place2 = leave_expire(company, leave_type, date).round(2)
    place3 = ((place1 - place2) / 365 * assigned_leave_type_amount(company,leave_type)).round(2) + add_leaves
    if place3 > leave_amount_max + add_leaves
      place3 = leave_amount_max + add_leaves
    elsif place3 < 0
      place3 = 0
    end
    if Time.zone.today > leave_start
      value = place3 -  segmented_leaves(moving_date..moving_date_end, company, leave_type)[:amount]
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

  def prorate_accrual_calc(company, leave_type, date = nil)
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
    # leave_expire = company.company_leave_setting.leave_month_expiration
    # leave_start_with_expiration = leave_start + leave_expire.months
    # leave_amount_max = (leave_settings.leave_month_expiration / 12 * assigned_leave_type_amount(company,leave_type).to_f)
    if leave_end.present?
      ending = leave_end
    else
      if date.present?
        ending = date
      else
        ending = Time.zone.today
      end
    end
    available = (ending.at_beginning_of_month - leave_start)
    # if available > leave_amount_max
    #   available = leave_amount_max
    # end
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
    available = ((Time.zone.today - leave_start) / Time.days_in_year * assigned_leave_type_amount(company, leave_type)).to_f
  end

  def leave_add_calculation(company, leave_type, date = nil)
    if company.company_leave_setting.prorate_accrual == true
      prorate_accrual_calc(company, leave_type, date)
    else
      # non_prorate_accrual_calc(company, leave_type)
      prorate_accrual_calc(company, leave_type, date)
    end
  end

  def leave_expire(company, leave_type, date = nil)
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
    if date.present?
      ending = date
    else
      ending = Time.zone.today
    end


    if expiration_start < ending
      unless leave_end.blank?
        ending = leave_end
      end
      expire = (ending.at_beginning_of_month - expiration_start)
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
    if Time.zone.today - (leave_reduction.date + expiration.months) < 0
      return leave_reduction.amount
    else
      return 0
    end
  end

  def self.find_first_by_auth_conditions warden_conditions
  conditions = warden_conditions.dup

    if (email = conditions.delete(:email)).present?
      where(email: email.downcase).first
    elsif conditions.has_key?(:reset_password_token)
      where(reset_password_token: conditions[:reset_password_token]).first
    end
  end

  def self.import(file, company, user)
    require 'securerandom'
	  spreadsheet = open_spreadsheet(file)
	  header = spreadsheet.row(1)
    last_row = spreadsheet.last_row
    # CSV not working with last_row fix
    if File.extname(file.original_filename) == '.csv'
      last_row = last_row - 1
    end
	  (2..last_row).each do |i|

      upassword = SecureRandom.hex(4).to_s
	    row = Hash[[header, spreadsheet.row(i)].transpose]

      profile_check = Profile.find_by(first_name: row["First Name"], last_name: row["Last Name"])
      user = find_by_id(profile_check.user_id) unless profile_check.nil?
      user = new if profile_check.nil?
      user.time_zone = "Singapore"
      user.email = row["Email"]
      user.password = upassword if user.password.nil?
      user.skip_confirmation!
      user.save!
      user.confirm

      if profile_check.nil?
        profile = user.build_profile
  	    profile.first_name = row["First Name"] if profile.first_name.nil?
        profile.last_name = row["Last Name"] if profile.last_name.nil?
        profile.save!
      end

			employment = user.employments.build
			employment.start_date = Date.parse(row['Start Date'].to_s).strftime("%Y/%m/%d")
      employment.company_id = company.id
      employment.regularized = true if row["Regularized?"] == true
      employment.acceptance = true
      employment.acceptor_id = user.employments.last.id
      employment.role_id = 2
			employment.save!

      password = UserImportPassword.new
      password.user_id = user.id
      password.password = upassword
      password.save!
		end
  end

  def self.mass_delete(file, company, user)
		spreadsheet = open_spreadsheet(file)
		header = spreadsheet.row(1)
    last_row = spreadsheet.last_row
    # CSV not working with last_row fix
    if File.extname(file.original_filename) == '.csv'
      last_row = last_row - 1
    end
		(2..last_row).each do |i|
			row = Hash[[header, spreadsheet.row(i)].transpose]
      employment = Employment.where(user_id: Profile.where(first_name: row['First Name'], last_name: row['Last Name']).first.user_id, company_id: company.id).last
			self.find_by(
				id: employment.user_id
			).destroy
		end
	end

  def self.open_spreadsheet(file)
    case File.extname(file.original_filename)
    when ".csv" then Roo::CSV.new(file.path, file_warning: :ignore)
    when ".xls" then Roo::Excel.new(file.path, file_warning: :ignore)
    when ".xlsx" then Roo::Excelx.new(file.path, file_warning: :ignore)
    else raise "Unknown file type: #{file.original_filename}"
    end
  end

  def confirmation_required?
    false
  end
end
