class CreateAddresses < ActiveRecord::Migration
  def change
    create_table :addresses do |t|
      t.string :last_name
      t.string :first_name
      t.string :address_1
      t.string :address_2
      t.string :city
      t.string :state
      t.string :country
      t.string :post_code
      t.string :phone
      t.string :organization
      t.timestamps
    end
  end 
end