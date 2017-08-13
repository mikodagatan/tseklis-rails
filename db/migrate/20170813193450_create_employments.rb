class CreateEmployments < ActiveRecord::Migration[5.1]
  def change
    create_table :employments do |t|
    t.date				:start_date
    t.date 				:end_date

    t.string				:position
    t.integer			:salary

		t.timestamps
    end
  end
end
