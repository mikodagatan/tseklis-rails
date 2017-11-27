class AddSalaryToInviteToken < ActiveRecord::Migration[5.1]
  def change
    add_column :invites, :salary, :integer
  end
end
