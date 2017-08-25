class CreateLeaves < ActiveRecord::Migration[5.1]
  def change
    create_table :leave_amounts do |t|
    	t.date		:date
    	t.decimal :amount

    	t.integer :leave_request_id

    	t.timestamps
    end
  end
end
