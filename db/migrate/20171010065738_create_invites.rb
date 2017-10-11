class CreateInvites < ActiveRecord::Migration[5.1]
  def change
    create_table :invites do |t|
      t.string :email
      t.integer :company_id
      t.integer :sender_id
      t.integer :recipient_id
      t.string  :first_name
      t.string  :last_name
      t.date    :start_date
      t.string  :token
      t.timestamps
    end
  end
end
