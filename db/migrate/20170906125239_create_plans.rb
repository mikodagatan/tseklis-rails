class CreatePlans < ActiveRecord::Migration[5.1]
  def change
    create_table :plans do |t|
      t.string :name
      t.decimal :price
      t.attachment :photo
      t.boolean :active, default: true
      t.text :description
      
      t.timestamps
    end
  end
end
