class DepHeadOnboarding < ApplicationRecord
  scope :ordered_dep_head, -> {
    order("created_at DESC")
  }
  belongs_to :department
  belongs_to :employment, required: false

  validates_presence_of :start_date
end
