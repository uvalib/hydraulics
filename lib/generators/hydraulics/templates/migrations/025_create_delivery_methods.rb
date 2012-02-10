class CreateDeliveryMethods < ActiveRecord::Migration

  def change
    create_table :delivery_methods do |t|
      t.string :label
      t.string :description
      t.boolean :is_internal_use_only, :default => false, :null => false
      t.timestamps
    end

    add_index :delivery_methods, :label

    create_table :delivery_methods_orders, :id => false do |t|
      t.references :delivery_method, :order
    end

    add_foreign_key :delivery_methods_orders, :delivery_methods
    add_foreign_key :delivery_methods_orders, :orders
    
  end
end