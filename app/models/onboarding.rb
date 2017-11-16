class Onboarding < ApplicationRecord
  belongs_to :employment
  belongs_to :project
  has_one :user, through: :employment
  has_one :department, through: :project

  validates_presence_of :start_date
end
