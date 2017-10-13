class CreateNotifications < ActiveRecord::Migration[5.1]
  def change
    create_table :notifications do |t|
      t.references :user, index: true
      t.references :acting_user, index: true
      t.references :employment, index: true
      t.references :leave_request, index: true
      t.string :notice_type
      t.boolean :read

      t.timestamps
    end
    add_foreign_key :notifications, :users
    add_foreign_key :notifications, :users, column: :acting_user_id
    add_foreign_key :notifications, :employments
    add_foreign_key :notifications, :leave_requests
  end
end
