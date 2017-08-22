class AddDetailsToLeaveRequests < ActiveRecord::Migration[5.1]
  def change
    add_column :leave_requests, :reviewed, :boolean
  end
end
