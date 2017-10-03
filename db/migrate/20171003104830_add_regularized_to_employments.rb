class AddRegularizedToEmployments < ActiveRecord::Migration[5.1]
  def up
    add_column :employments, :regularized, :boolean, default: true
  end
  def down
    remove_columns :employments, :regularized
  end
end
