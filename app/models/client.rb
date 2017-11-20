class Client < ApplicationRecord
  belongs_to :company
  has_many :projects
  has_many :project_times, through: :projects
  has_many :onboardings, through: :projects
  has_many :companies, through: :projects
  has_many :employments, through: :onboardings

end
