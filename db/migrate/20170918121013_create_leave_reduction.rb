class CreateLeaveReduction < ActiveRecord::Migration[5.1]
  def change
    create_table :leave_reductions do |t|
      t.date        :date
      t.decimal     :amount
      t.integer     :employment_id
      t.integer     :leave_type_id
      
      t.timestamps
    end
  end
end
