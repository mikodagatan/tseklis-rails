class CreateEmployments < ActiveRecord::Migration[5.1]
  def change
    create_table :employments do |t|
    t.date				:start_date
    t.date 				:end_date

    t.string			:position
    t.integer			:salary

    t.integer			:company_id
    t.integer			:user_id
		t.timestamps
    end
  end
end
