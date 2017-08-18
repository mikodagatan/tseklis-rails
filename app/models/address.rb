class Address < ApplicationRecord
belongs_to :company

validates :first_line, presence: { message: "Please enter the First line"}

validates :second_line, presence: { message: "Please enter the Second line"}
end
