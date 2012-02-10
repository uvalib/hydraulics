class CreateDeliveryMethods < ActiveRecord::Migration

  def change
    create_table :delivery_methods do |t|
      t.string :label
      t.string :description
      t.integer :is_internal_use_only
      t.timestamps
    end

    add_index :delivery_methods, :label

    create_table :delivery_methods_orders, :id => false do |t|
      t.references :delivery_methods, :orders
    end
  end
end