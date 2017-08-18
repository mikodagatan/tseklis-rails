class CreateLeaveTypeAmounts < ActiveRecord::Migration[5.1]
  def change
    create_table :leave_type_amounts do |t|
    	t.integer				:amount

    	t.integer				:leave_type_id

    	t.integer				:company_id

    	t.timestamps
    end
  end
end
