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
      t.string :header_description_message
      t.string :endorsement_header
      t.string :endorsement_description
      t.string :testimonial_header
      t.string :testimonial_descriptionn
      t.string :features_header
      t.string :features_description
      t.string :owners_header
      t.string :owners_description
      t.string :contact_messages_header
      t.string :contact_messages_description
      t.string :plans_header
      t.string :plans_description

      t.integer :user_id

      t.timestamps
    end
  end
end
