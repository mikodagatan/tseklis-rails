class CreateProjectHeadOnboardings < ActiveRecord::Migration[5.1]
  def change
    create_table :project_head_onboardings do |t|
      t.integer     :employment_id
      t.integer     :department_id
      t.date        :start_date
      t.date        :end_date
      t.timestamps
    end
  end
end
