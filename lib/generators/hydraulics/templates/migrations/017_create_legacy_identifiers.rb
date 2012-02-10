class CreateLegacyIdentifiers < ActiveRecord::Migration
  def change
    create_table :legacy_identifiers do |t|
      t.string :label
      t.string :description
      t.string :legacy_identifier
      t.timestamps
    end

    add_index :legacy_identifiers, :label
    add_index :legacy_identifiers, :legacy_identifier

    create_table :bibls_legacy_identifiers, :id => false do |t|
      t.references :bibl, :legacy_identifier
    end

    add_index :bibls_legacy_identifiers, :bibl_id
    add_index :bibls_legacy_identifiers, :legacy_identifier_id

    create_table :legacy_identifiers_master_files, :id => false do |t|
      t.references :legacy_identifier, :master_file
    end
  end
end
