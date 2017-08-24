class Holiday < ApplicationRecord
	belongs_to :company
	has_many :emloyments
	has_many :users, through: :employments

	validates :name, 
		length: { minimum: 3, maximum: 20}

	
end