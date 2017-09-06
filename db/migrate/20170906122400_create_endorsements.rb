class CreateEndorsements < ActiveRecord::Migration[5.1]
  def change
    create_table :endorsements do |t|
      t.string :name
      t.attachment :photo
      t.string :link
      t.string :award_name
      t.decimal :rating
      t.string :description
      t.boolean :active, default: true

      t.timestamps
    end
  end
end
