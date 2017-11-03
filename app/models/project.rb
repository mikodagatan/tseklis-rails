class Project < ApplicationRecord
  belongs_to :department
  has_one :company, through: :department
  has_many :employments, through: :onboardings
  has_many :users, through: :employments
  has_many :project_times
end
