class Holiday < ApplicationRecord
	belongs_to :company
	has_many :emloyments
	has_many :users, through: :employments
end