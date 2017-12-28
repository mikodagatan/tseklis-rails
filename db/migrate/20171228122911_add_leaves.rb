class AddLeaves < ActiveRecord::Migration[5.1]
  def change
    create_table :add_leaves do |t|
      t.integer   :amount
      t.integer   :leave_type_id
      t.integer   :employment_id

      t.timestamps
    end
  end
end
