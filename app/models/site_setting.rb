class SiteSetting < ApplicationRecord
  has_attached_file :site_icon, styles: { medium: "300x300>", thumb: "100x100>" }, default_url: "/images/:style/missing.png"
  validates_attachment_content_type :site_icon, content_type: /\Aimage\/.*\z/

  has_attached_file :site_logo, styles: { medium: "300x300>", thumb: "100x100>" }, default_url: "/images/:style/missing.png"
  validates_attachment_content_type :site_logo, content_type: /\Aimage\/.*\z/
end
