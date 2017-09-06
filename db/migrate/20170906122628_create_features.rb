class CreateFeatures < ActiveRecord::Migration[5.1]
  def change
    create_table :features do |t|
      t.string :name
      t.attachment :photo
      t.attachment :video
      t.string :short_description
      t.string :long_description
      t.boolean :active, default: true

      t.timestamps
    end
  end
end
