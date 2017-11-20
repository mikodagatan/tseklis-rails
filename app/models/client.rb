class Client < ApplicationRecord
  has_many :projects
  has_many :project_times, through: :projects
  has_many :onboardings, through: :projects
  has_many :companies, through: :projects
end
