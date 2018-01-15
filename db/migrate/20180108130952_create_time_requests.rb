class CreateTimeRequests < ActiveRecord::Migration[5.1]
  def change
    create_table :time_requests do |t|
      t.string :title
      t.string :in_out
      t.date   :date
      t.time   :time
      t.integer :employment_id
    end
  end
end
