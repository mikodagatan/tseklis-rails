class Cost < ApplicationRecord
  belongs_to :employment
  has_one :user, through: :employment
  has_one :profile, through: :user
  has_one :company, through: :user
end
