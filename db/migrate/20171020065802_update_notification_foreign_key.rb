class UpdateNotificationForeignKey < ActiveRecord::Migration[5.1]
  def up
    # remove the old foreign_key
    remove_foreign_key :notifications, :users
    remove_foreign_key :notifications, :users
    remove_foreign_key :notifications, :employments
    remove_foreign_key :notifications, :leave_requests

    # add the new foreign_key
    add_foreign_key :notifications, :users, on_delete: :cascade
    add_foreign_key :notifications, :users, column: :acting_user_id, on_delete: :cascade
    add_foreign_key :notifications, :employments, on_delete: :cascade
    add_foreign_key :notifications, :leave_requests, on_delete: :cascade
  end
  
  def down
  end
end
