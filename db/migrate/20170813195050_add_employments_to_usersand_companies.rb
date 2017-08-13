class AddEmploymentsToUsersandCompanies < ActiveRecord::Migration[5.1]
  def change
  	add_column :companies, :employment_id, :integer
  	add_column :users, :employment_id, :integer
  end
end
