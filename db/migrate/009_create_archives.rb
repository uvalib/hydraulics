class CreateArchives < ActiveRecord::Migration
  def change
    create_table :archives do |t|
      t.string :name
      t.string :description
      t.integer :units_count, :default => 0

      t.timestamps
    end
    
    add_index :archives, :name, :unique => true

    add_foreign_key :units, :archives
  end
end