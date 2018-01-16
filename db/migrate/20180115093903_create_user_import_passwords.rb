class CreateUserImportPasswords < ActiveRecord::Migration[5.1]
  def change
    create_table :user_import_passwords do |t|
      t.integer :user_id
      t.string :password

      t.timestamps
    end
  end
end
