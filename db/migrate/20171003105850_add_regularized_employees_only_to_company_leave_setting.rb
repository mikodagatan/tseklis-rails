class AddRegularizedEmployeesOnlyToCompanyLeaveSetting < ActiveRecord::Migration[5.1]
  def up
    add_column :company_leave_settings, :regularized_employees_only, :boolean, default: true
  end
  def down
    remove_columns :company_leave_settings, :regularized_employees_only
  end
end
