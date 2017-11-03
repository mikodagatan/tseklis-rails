class CreateProjects < ActiveRecord::Migration[5.1]
  def change
    create_table :projects do |t|
      t.string      :name
      t.integer     :department_id
      t.integer     :project_manager_id
      t.timestamps
    end

  end
end
