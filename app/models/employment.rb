class Employment < ApplicationRecord
	belongs_to :employment

	has_one :user, through: :employment
end
