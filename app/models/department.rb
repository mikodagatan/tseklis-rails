class Department < ApplicationRecord
  belongs_to :company
  has_many :projects
  has_many :project_times, through: :projects
  has_many :employments, through: :projects
  has_many :users, through: :employments
  has_many :dep_head_onboardings, dependent: :destroy

  accepts_nested_attributes_for :dep_head_onboardings, allow_destroy: true, reject_if: proc { |attributes| attributes['employment_id'].blank? }

end
