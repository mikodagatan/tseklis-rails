class AddOnboardingsToProjectTimes < ActiveRecord::Migration[5.1]
  def change
    add_column :project_times, :onboarding_id, :integer
    add_column :project_times, :date, :date
  end
end
