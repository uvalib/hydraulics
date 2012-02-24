class CreateUseRights < ActiveRecord::Migration
  def change
    create_table :use_rights do |t|
      t.string :name
      t.string :description
      t.integer :bibls_count, :default => 0
      t.integer :components_count, :default => 0
      t.integer :master_files_count, :default => 0
      t.integer :units_count, :default => 0
      
      t.timestamps
    end

    add_index :use_rights, :name, :unique => true

    add_foreign_key :bibls, :use_rights
    add_foreign_key :components, :use_rights
    add_foreign_key :master_files, :use_rights
    add_foreign_key :units, :use_rights
  end
end
