class CreateUnitImportSources < ActiveRecord::Migration

  def change
    create_table :unit_import_sources do |t|
      t.integer :unit_id, :default => 0, :null => false
      t.string :standard # Iview, Bagit
      t.string :version # 0.97, 2
      t.text :source, :limit => 2147483647 # Entire XML file
      t.timestamps
    end

    add_index :unit_import_sources, :unit_id
    
    add_foreign_key :unit_import_sources, :units
  end
end