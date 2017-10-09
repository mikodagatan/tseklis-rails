class AddManagerToEmployments < ActiveRecord::Migration[5.1]
  def change
    add_reference :employments, :manager, index: true
  end
end
