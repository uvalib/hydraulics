class CreateDepartments < ActiveRecord::Migration
  def change
    create_table :departments do |t|
      t.string :name
      t.integer :customers_count, :default => 0

      t.timestamps
    end
    
    add_index :departments, :name, :unique => true

    add_foreign_key :customers, :departments
    
  end
end