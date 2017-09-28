class ChangeColumnActiveOnTestimonials < ActiveRecord::Migration[5.1]
  def self.up
    change_column :testimonials, :active, :boolean, default: true
  end

  def self.down
    change_column :testimonials, :active, :boolean
  end
end
