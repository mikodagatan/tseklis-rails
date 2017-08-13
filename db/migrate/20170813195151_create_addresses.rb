class CreateAddresses < ActiveRecord::Migration[5.1]
  def change
    create_table :addresses do |t|
    	t.string  :name
      t.string 	:first_line
      t.string 	:second_line
      t.string 	:city_town
      t.string 	:province
      t.string 	:country
      t.integer :zip_code
      t.references  :addressable, polymorphic: true, index: true

      t.timestamps
    end
  end

end
