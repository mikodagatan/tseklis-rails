class CreateLeaveReviews < ActiveRecord::Migration[5.1]
  def change
    create_table :leave_reviews do |t|
    	t.integer :leave_request_id
    	t.boolean :leave_allow


    	t.integer :profile_id

    	t.timestamps
    end
  end
end
