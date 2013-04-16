class CreateMasterFiles < ActiveRecord::Migration
  def change
    create_table :master_files do |t|
      
      # External Relationships
      t.references :availability_policy, :component, :indexing_scenario, :use_right
      t.integer :unit_id, :default => 0, :null => false

      # Counters
      t.integer :automation_messages_count, :default => 0
      
      # General Master File Information
      t.string :description
      t.string :filename
      t.integer :filesize
      t.string :md5
      t.string :title

      # DL objects
      t.text :dc
      t.text :desc_metadata
      t.boolean :discoverability, :default => false # MasterFiles are by default not uniquely discoverable
      t.string :pid
      t.text :rels_ext
      t.text :rels_int
      t.text :solr, :limit => 16777215
      t.text :transcription_text
      t.datetime :date_dl_ingest
      t.datetime :date_dl_update
      t.datetime :date_archived

      t.string :tech_meta_type # Used to distinguish what kind of MasterFile object this is (i.e. image, audio, video, etc...)
      t.timestamps
    end
    
    add_index :master_files, :unit_id
    add_index :master_files, :component_id
    add_index :master_files, :use_right_id
    add_index :master_files, :indexing_scenario_id
    add_index :master_files, :availability_policy_id
    add_index :master_files, :filename
    add_index :master_files, :title
    add_index :master_files, :pid
    add_index :master_files, :tech_meta_type

    add_foreign_key :master_files, :units
    
  end
end