class AddIncludeWeekendsColumnToCompanyLeaveSettings < ActiveRecord::Migration[5.1]
  def change
  	add_column :company_leave_settings, :include_weekends, :boolean, default: true
  end
end
