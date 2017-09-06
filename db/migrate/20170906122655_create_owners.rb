class CreateOwners < ActiveRecord::Migration[5.1]
  def change
    create_table :owners do |t|
      t.string :name
      t.string :designation
      t.string :quote
      t.text :description
      t.attachment :photo
      t.attachment :video
      t.boolean :active, default: true

      t.timestamps
    end
  end
end
