class CreateMasterFiles < ActiveRecord::Migration
  def change
    create_table :master_files do |t|
      
      # External Relationships
      t.references :indexing_scenario, :availability_policy, :component, :unit, :use_right

      # Counters
      t.integer :automation_messages_count
      
      # General Master File Information
      t.string :description
      t.string :filename
      t.integer :filesize
      t.string :md5
      t.string :title

      # DL objects
      t.text :dc
      t.text :desc_metadata
      t.boolean :discoverability, :null => false, :default => 0
      t.boolean :locked_desc_metadata, :null => false, :default => 0
      t.string :pid
      t.text :rels_ext
      t.text :rels_int
      t.text :solr, :limit => 16777215
      t.text :transcription_text
      t.datetime :date_ingested_into_dl

      t.string :tech_meta_type # Used to distinguish what kind of MasterFile object this is (i.e. image, audio, video, etc...)
      t.timestamps
    end
    
    add_index :master_files, :unit_id
    add_index :master_files, :component_id
    add_index :master_files, :use_right_id
    add_index :master_files, :availability_policy_id
    add_index :master_files, :tech_meta_type
    add_index :master_files, :filename
    add_index :master_files, :title
    add_index :master_files, :pid
    add_index :master_files, [:unit_id, :filename]

    add_foreign_key :master_files, :units
    
  end
end