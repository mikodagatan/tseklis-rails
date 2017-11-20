class Project < ApplicationRecord
  belongs_to :department
  belongs_to :client, required: false
  has_one :company, through: :department
  has_many :employments, through: :onboardings
  has_many :users, through: :employments
  has_many :project_times
  has_many :project_head_onboardings
  has_many :onboardings

  accepts_nested_attributes_for :project_head_onboardings, allow_destroy: true, reject_if: proc { |attributes| attributes['employment_id'].blank? }

  accepts_nested_attributes_for :onboardings, allow_destroy: true, reject_if: proc { |attributes| attributes['employment_id'].blank? }

  accepts_nested_attributes_for :project_times, allow_destroy: true, reject_if: proc { |attributes| attributes['employment_id'].blank? }
end
