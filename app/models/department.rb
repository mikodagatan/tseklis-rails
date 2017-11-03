class Department < ApplicationRecord
  belongs_to :company
  has_many :projects
  has_many :project_times, through: :projects
  has_many :employments, through: :projects
  has_many :users, through: :employments
end
