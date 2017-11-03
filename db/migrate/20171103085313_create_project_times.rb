class CreateProjectTimes < ActiveRecord::Migration[5.1]
  def change
    create_table :project_times do |t|
      t.decimal      :duration
      t.integer      :project_id
      t.timestamps
    end
  end
end
