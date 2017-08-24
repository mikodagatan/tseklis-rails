class CreateHolidays < ActiveRecord::Migration[5.1]
  def change
    create_table :holidays do |t|
    	t.string 	:name
    	t.date 		:date

    	t.integer :company_id

    	t.timestamps
    end
  end
end
