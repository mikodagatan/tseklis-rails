class CreateClients < ActiveRecord::Migration[5.1]
  def change
    create_table :clients do |t|
      t.string :name, uniqueness: true
    end
    add_column :projects, :client_id, :integer
  end
end
