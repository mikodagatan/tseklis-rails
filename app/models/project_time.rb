class ProjectTime < ApplicationRecord
  belongs_to :onboarding, required: false
  belongs_to :project
  has_one :employment, through: :onboarding
  # has_one :project, through: :onboarding
  has_one :user, through: :employment
  has_one :company, through: :project
  has_one :department, through: :project

  validates_presence_of :project_id, :onboarding_id, required: false

  validate :duration_input


  def duration_input
    if duration <= 0
      errors.add(:duration, "duration bad")
    end
  end
end
