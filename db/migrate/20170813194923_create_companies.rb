class CreateCompanies < ActiveRecord::Migration[5.1]
  def change
    create_table :companies do |t|
    	t.string			:name
      t.attachment  :logo
    	t.boolean			:active, default: true

    	t.integer			:plan_id

    	t.timestamps
    end
  end
end
