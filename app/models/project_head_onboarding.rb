class ProjectHeadOnboarding < ApplicationRecord
  scope :ordered_project_head, -> {
    order("created_at DESC")
  }
  belongs_to :project
  belongs_to :employment, required: false

  validates_presence_of :start_date
end
