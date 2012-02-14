class CreateDvdDeliveryLocations < ActiveRecord::Migration

  def change
    create_table :dvd_delivery_locations do |t|
      t.string :name
      t.text :email_desc
      t.integer :orders_count, :default => 0
      t.timestamps
    end

    add_index :dvd_delivery_locations, :name, :unique => true
    add_foreign_key :orders, :dvd_delivery_locations
  end
end