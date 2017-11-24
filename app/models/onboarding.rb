class Onboarding < ApplicationRecord
  belongs_to :employment
  belongs_to :project
  has_one :user, through: :employment
  has_one :department, through: :project
  has_many :project_times

  validates_presence_of :start_date

  accepts_nested_attributes_for :project_times


end
