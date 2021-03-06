class CreateUnits < ActiveRecord::Migration

  def change
    create_table :units do |t|

      # External Relationships
      # Note: Bibl is not a required reference because incoming patron requests create Unit records but no Bibl records.
      t.references :archive, :availability_policy, :bibl, :heard_about_resource, :indexing_scenario, :use_right # non-required references
      t.integer :order_id, :default => 0, :null => false # required reference (zero will fail foreign key constraint)
      t.integer :intended_use_id, :default => 0, :null => false # required reference (zero will fail foreign key constraint)

      # Counters
      t.integer :master_files_count, :default => 0
      t.integer :automation_messages_count, :default => 0

      # Production Management
      t.datetime :date_archived
      t.datetime :date_materials_received # Date materials delivered to production unit.
      t.datetime :date_materials_returned # Date materials returned to patron, stacks, etc...
      t.datetime :date_patron_deliverables_ready
      t.text :patron_source_url
      t.boolean :remove_watermark, :null => false, :default => 0 # Override default inclusion of watermark on certain image deliverables
      t.text :special_instructions
      t.text :staff_notes
      t.integer :unit_extent_estimated # Pulled from request form; patron estimate of scope of digtization
      t.integer :unit_extent_actual
      t.string :unit_status    
      
      # Digital Library Information
      t.datetime :date_queued_for_ingest # Datetime when DL ingestion begins
      t.datetime :date_dl_deliverables_ready # Datetime when DL ingestion finishes
      t.boolean :master_file_discoverability, :null => false, :default => 0 # Determines if MasterFile objects belonging will be uniquely discoverable through index and repository
      t.boolean :exclude_from_dl, :null => false, :default => 0
      t.boolean :include_in_dl, :null => false, :default => 0
          
      t.timestamps
    end

    add_index :units, :archive_id
    add_index :units, :availability_policy_id
    add_index :units, :bibl_id
    add_index :units, :date_archived
    add_index :units, :date_dl_deliverables_ready
    add_index :units, :heard_about_resource_id
    add_index :units, :indexing_scenario_id
    add_index :units, :intended_use_id
    add_index :units, :order_id
    add_index :units, :use_right_id

    add_foreign_key :units, :orders
  end
end