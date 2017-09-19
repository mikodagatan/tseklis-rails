class CreateLeaveReduction < ActiveRecord::Migration[5.1]
  def change
    create_table :leave_reductions do |t|
      t.decimal     :amount
      t.integer     :employment_id
      t.timestamps
    end
  end
end
