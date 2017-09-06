class CreateTestimonials < ActiveRecord::Migration[5.1]
  def change
    create_table :testimonials do |t|
      t.string :name
      t.string :company_name
      t.attachment :photo
      t.attachment :video
      t.string :description
      t.boolean :active

      t.timestamps
    end
  end
end
