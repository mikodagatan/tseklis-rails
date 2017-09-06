class CreateFeatures < ActiveRecord::Migration[5.1]
  def change
    create_table :features do |t|
      t.string :name
      t.attachment :photo
      t.attachment :video
      t.text :short_description
      t.text :long_description
      t.boolean :active, default: true

      t.timestamps
    end
  end
end
