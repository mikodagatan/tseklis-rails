class CreateLandingPageSettings < ActiveRecord::Migration[5.1]
  def change
    create_table :landing_page_settings do |t|
      t.attachment :photo_1
      t.attachment :photo_2
      t.attachment :photo_3
      t.attachment :photo_4
      t.attachment :video_1
      t.attachment :video_2
      t.attachment :video_3
      t.attachment :video_4
      t.attachment :call_to_action_background
      t.string :header_message
      t.string :subheader_message
      t.text :header_description_message
      t.string :endorsement_header
      t.text :endorsement_description
      t.string :testimonial_header
      t.text :testimonial_descriptionn
      t.string :features_header
      t.text :features_description
      t.string :owners_header
      t.text :owners_description
      t.string :contact_messages_header
      t.text :contact_messages_description
      t.string :plans_header
      t.text :plans_description

      t.integer :user_id

      t.timestamps
    end
  end
end
