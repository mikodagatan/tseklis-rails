class CreateRejectionMessage < ActiveRecord::Migration[5.1]
  def change
    create_table :rejection_messages do |t|
      t.text        :description
      t.integer     :leave_request_id
      t.timestamps
    end
  end
end
