class CreateCustomers < ActiveRecord::Migration
  def change
    create_table :customers do |t|
      t.references :department, :academic_status, :heard_about_service # non-required references
      t.string :last_name
      t.string :first_name
      t.string :email
      t.string :organization
      t.integer :orders_count, :default => 0
      t.integer :master_files_count, :default => 0
      t.timestamps
    end
    
    add_index :customers, :last_name
    add_index :customers, :first_name
    add_index :customers, :email
    add_index :customers, :academic_status_id
    add_index :customers, :department_id
    add_index :customers, :heard_about_service_id

  end
end