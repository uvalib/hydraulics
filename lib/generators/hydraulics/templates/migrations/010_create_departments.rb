class CreateDepartments < ActiveRecord::Migration
  def change
    create_table :departments do |t|
      t.string :name

      t.timestamps
    end
    
    add_index :departments, :name, :unique => truemm

    add_foreign_key :customers, :departments
    
  end
end