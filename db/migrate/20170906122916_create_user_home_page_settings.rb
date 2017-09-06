class CreateUserHomePageSettings < ActiveRecord::Migration[5.1]
  def change
    create_table :user_home_page_settings do |t|
      t.attachment :create_company_photo
      t.attachment :connect_company_photo
      t.attachment :company_settings_photo

      t.timestamps
    end
  end
end
