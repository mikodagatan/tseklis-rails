class CreateEmployments < ActiveRecord::Migration[5.1]
  def change
    create_table :employments do |t|
    t.date				:start_date
    t.date 				:end_date

    t.decimal			:salary

    t.boolean           :inactive, default: false 

    t.boolean           :acceptance
    t.integer           :acceptor_id

    t.integer			:company_id
    t.integer			:user_id
    t.integer           :role_id   

		t.timestamps
    end
  end
end
