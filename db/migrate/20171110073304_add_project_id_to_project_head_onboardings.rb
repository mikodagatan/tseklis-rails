class AddProjectIdToProjectHeadOnboardings < ActiveRecord::Migration[5.1]
  def change
    add_column :project_head_onboardings, :project_id, :integer
  end
end
