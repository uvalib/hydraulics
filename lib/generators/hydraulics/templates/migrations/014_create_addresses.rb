class CreateAddresses < ActiveRecord::Migration
  def change
    create_table :addresses do |t|
      # Custom polymorphism
      t.integer :addressable_id, :null => false
      t.string :addressable_type, :null => false, :limit => 20
      t.string :address_type, :null => false, :limit => 20

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