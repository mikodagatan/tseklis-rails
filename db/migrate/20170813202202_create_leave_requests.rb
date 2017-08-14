class CreateLeaveRequests < ActiveRecord::Migration[5.1]
  def change
    create_table :leave_requests do |t|
    	t.string  :leave_title
    	t.string  :leave_type
    	t.text 		:leave_description
    	t.date 		:leave_start_date
    	t.date 		:leave_end_date

    	t.integer :profile_id

    	t.timestamps
    end
  end
end
