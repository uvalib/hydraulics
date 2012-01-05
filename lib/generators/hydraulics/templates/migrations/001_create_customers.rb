class CreateCustomers < ActiveRecord::Migration
  def change
    create_table :customers do |t|
      t.references :heard_about_services
      t.references :departments
      t.references :academic_statuses
      t.string :last_name
      t.string :first_name
      t.string :address_1
      t.string :address_2
      t.string :city
      t.string :state
      t.string :country
      t.string :post_code
      t.string :phone
      t.string :email
      t.string :organization
      t.integer :orders_count, :default => 0
      t.timestamps
    end
    
    add_index :customers, :last_name
    add_index :customers, :first_name
    add_index :customers, :email
    add_index :customers, :academic_status_id
    add_index :customers, :department_id
    add_index :customers, :heard_about_service_id

    add_foreign_key :customers, :academic_statuses
    add_foreign_key :customers, :departments
    add_foreign_key :customers, :heard_about_services
  end
end