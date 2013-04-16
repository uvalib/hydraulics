class CreateAcademicStatuses < ActiveRecord::Migration
  def change
    create_table :academic_statuses do |t|
      t.string :name
      t.integer :customers_count, :default => 0
      
      t.timestamps
    end

    add_index :academic_statuses, :name, :unique => true

    add_foreign_key :customers, :academic_statuses
    
  end
end
