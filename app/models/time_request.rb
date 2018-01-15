class TimeRequest < ApplicationRecord
  belongs_to :employment

  # validates :time_registered, format: { with: /([01]?[0-9]|2[0-3]):[0-5][0-9]/, message: "Please enter a 24-hour time format. Example: '13:21' for 1:21 pm" }
  
end
