class CreateCosts < ActiveRecord::Migration[5.1]
  def change
    create_table :costs do |t|
      t.integer :salary
      t.integer :overhead
      t.date :start_date
      t.date :end_date
      t.integer :employment_id
      t.integer :company_id

      t.timestamps
    end
  end
end
