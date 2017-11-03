class CreateOnboardings < ActiveRecord::Migration[5.1]
  def change
    create_table :onboardings do |t|
      t.integer     :employment_id
      t.integer     :project_id
      t.date        :start_date
      t.date        :end_date
      t.timestamps
    end
  end
end
