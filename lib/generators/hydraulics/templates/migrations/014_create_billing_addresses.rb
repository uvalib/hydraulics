class CreateBillingAddresses < ActiveRecord::Migration

  def change
    create_table :billing_addresses do |t|
      t.references :agency, :customer
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

    add_index :billing_address, :agency_id, :unique => true
    add_index :billing_address, :customer_id, :unique => true

    add_foreign_key :billing_addresses, :agencies
    add_foreign_key :billing_addresses, :customers
  end 
end