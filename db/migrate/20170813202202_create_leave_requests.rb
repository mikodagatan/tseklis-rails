class CreateLeaveRequests < ActiveRecord::Migration[5.1]
  def change
    create_table :leave_requests do |t|
    	t.string    :title
    	t.text 		:description
    	t.date 		:start_date
        t.datetime  :start_time
    	t.date 		:end_date
        t.datetime  :end_time
        t.boolean   :acceptance
        t.integer   :acceptor_id
        t.integer   :leave_type_id
 
    	t.integer   :employment_id


    	t.timestamps
    end
  end
end
