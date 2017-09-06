class UserHomePageSetting < ApplicationRecord
  has_attached_file :create_company_photo, styles: { medium: "300x300>", thumb: "100x100>" }, default_url: "/images/:style/missing.png"
  validates_attachment_content_type :create_company_photo, content_type: /\Aimage\/.*\z/

  has_attached_file :connect_company_photo, styles: { medium: "300x300>", thumb: "100x100>" }, default_url: "/images/:style/missing.png"
  validates_attachment_content_type :connect_company_photo, content_type: /\Aimage\/.*\z/

  has_attached_file :company_settings_photo, styles: { medium: "300x300>", thumb: "100x100>" }, default_url: "/images/:style/missing.png"
  validates_attachment_content_type :company_settings_photo, content_type: /\Aimage\/.*\z/
end
