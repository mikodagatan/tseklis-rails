class Project < ApplicationRecord
  belongs_to :department
  belongs_to :client, required: false
  has_one :company, through: :department
  has_many :onboardings, dependent: :destroy
  has_many :employments, through: :onboardings
  has_many :users, through: :employments
  has_many :project_times, dependent: :destroy
  has_many :project_head_onboardings, dependent: :destroy


  accepts_nested_attributes_for :project_head_onboardings, allow_destroy: true, reject_if: proc { |attributes| attributes['employment_id'].blank? }

  accepts_nested_attributes_for :onboardings, allow_destroy: true, reject_if: proc { |attributes| attributes['employment_id'].blank? }

  accepts_nested_attributes_for :project_times, allow_destroy: true, reject_if: proc { |attributes| attributes['employment_id'].blank? }

  def current_project_manager
    self.project_head_onboardings.where(end_date: nil).last.employment if self.project_head_onboardings.present?
  end


end
