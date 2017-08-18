class CreateLeaveTypes < ActiveRecord::Migration[5.1]
  def change
    create_table :leave_types do |t|
    	t.string			:name
    	t.integer			:amount

    	t.integer			:company_id

    	t.timestamps
    end
  end
end
