class CreateSiteSettings < ActiveRecord::Migration[5.1]
  def change
    create_table :site_settings do |t|
      t.string :site_name, default: "Tseklis"
      t.text :site_description
      t.attachment :site_icon
      t.attachment  :site_logo

      t.timestamps
    end
  end
end
