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

    add_foreign_key :bibls_legacy_identifiers, :bibls
    add_foreign_key :bibls_legacy_identifiers, :legacy_identifiers

    create_table :legacy_identifiers_master_files, :id => false do |t|
      t.references :legacy_identifier, :master_file
    end

    add_index :legacy_identifiers_master_files, :legacy_identifier_id
    add_index :legacy_identifiers_master_files, :master_file_id

    add_foreign_key :legacy_identifiers_master_files, :legacy_identifiers
    add_foreign_key :legacy_identifiers_master_files, :master_files

    create_table :components_legacy_identifiers, :id => false do |t|
      t.references :component, :legacy_identifier
    end

    add_index :components_legacy_identifiers, :component_id
    add_index :components_legacy_identifiers, :legacy_identifier_id

    add_foreign_key :components_legacy_identifiers, :components
    add_foreign_key :components_legacy_identifiers, :legacy_identifiers

  end
end
