class ProjectTime < ApplicationRecord
  belongs_to :project
  belongs_to :employment
  has_one :user, through: :employment
  has_one :company, through: :project
  has_one :department, through: :project
end
