class CreateProfiles < ActiveRecord::Migration[5.1]
  def change
    create_table :profiles do |t|
    	t.integer :user_id
      t.string 	:first_name
      t.string 	:last_name
      t.string 	:position
      t.string 	:contact_email
    end
  end
end
