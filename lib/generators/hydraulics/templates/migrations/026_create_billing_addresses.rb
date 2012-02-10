class CreateBillingAddresses < ActiveRecord::Migration

  def change
    create_table :billing_address do |t|
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

    add_index :billing_address, :agency_id
    add_index :billing_address, :customer_id

    add_foreing_key :billing_addresses, :agencies
    add_foreing_key :billing_addresses, :customers
  end 
end