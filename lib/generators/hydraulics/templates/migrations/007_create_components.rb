class CreateComponents < ActiveRecord::Migration
  def change
    create_table :components do |t|
      t.integer :availability_policy_id
      t.integer :component_type_id
      t.integer :indexing_scenario_id
      t.integer :use_right_id
      t.integer :parent_component_id
      t.string :title
      t.text :content_desc
      t.string :date
      t.boolean :discoverability, :default => true # The defaul for Bibl objects is that they are discoverable
      t.string :exemplar
      t.string :pid # All Bibl objects get PIDs; only used if Bibl object is ingested into repository

      t.text :dc
      t.text :desc_metadata
      t.text :rels_ext
      t.text :rels_int
      t.text :solr, :limit => 16777215
      t.datetime :date_ingested_into_dl
      t.integer :master_files_count, :default => 0
      t.timestamps
    end

    add_index :components, :availability_policy_id
    add_index :components, :indexing_scenario_id
    add_index :components, :component_type_id
    add_index :components, :use_right_id

    add_foreign_key :components, :availability_policies

    change_table(:master_files, :bulk => true) do |t|
      t.foreign_key :components
    end

    create_table :bibls_components do |t|
      t.integer :bibl_id
      t.integer :component_id
    end

    add_index :bibls_components, :bibl_id
    add_index :bibls_components, :component_id

    add_foreign_key :bibls_components, :bibls
    add_foreign_key :bibls_components, :components

  end
end
