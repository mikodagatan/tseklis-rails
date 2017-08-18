class Address < ApplicationRecord
belongs_to :company

validates :first_line, presence: true
validates :second_line, presence: true
validates :city_town, presence: true
validates :province, presence: true
validates :country, presence: true
validates :zip_code, presence: true, numericality: { only_integer: true, greater_than: 0 }

end
