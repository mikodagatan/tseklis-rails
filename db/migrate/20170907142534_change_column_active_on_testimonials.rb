class ChangeColumnActiveOnTestimonials < ActiveRecord::Migration[5.1]
  def change
    change_column :testimonials, :active, :boolean, default: true
  end
end
