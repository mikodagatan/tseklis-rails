class AddAllowWeekendHolidayLeaveColumnToLeaveRequest < ActiveRecord::Migration[5.1]
  def change
    add_column :leave_requests, :allow_weekend_holiday_leave, :boolean, default: false 
  end
end
