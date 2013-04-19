class CreateBibls < ActiveRecord::Migration
  def change
    create_table :bibls do |t|
  
      # External References
      t.references :indexing_scenario, :availability_policy, :use_right
      t.integer :parent_bibl_id, :null => false, :default => 0, :references => nil
      
      # General information (i.e. fields never derived from outside source)
      t.datetime :date_external_update # If Bibl record created/updated from outside source
      t.string :description
      t.boolean :is_approved, :null => false, :default => 0  # boolean values should be 0 or 1 (disallow NULL)
      t.boolean :is_collection, :null => false, :default => 0
      t.boolean :is_in_catalog, :null => false, :default => 0
      t.boolean :is_manuscript, :null => false, :default => 0
      t.boolean :is_personal_item, :null => false, :default => 0
         
      # Catalog information, pulled from Blacklight/Solr, if available
      t.string :barcode, :call_number, :catalog_key, :creator_name, :creator_name_type, :genre, :issue, 
      :location, :resource_type, :series_title, :title, :title_control, :year, :year_type, :pid,
      :exemplar
      t.text :citation
      t.integer :copy
      
      # DL Objects Only
      t.text :dc
      t.text :desc_metadata
      t.boolean :discoverability, :default => true # The defaul for Bibl objects is that they are discoverable
      t.text :rels_ext
      t.text :rels_int
      t.text :solr, :limit => 16777215
      t.datetime :date_dl_ingest

      t.integer :automation_messages_count, :default => 0
      t.integer :orders_count, :default => 0
      t.integer :units_count, :default => 0
      t.integer :master_files_count, :default => 0
          
      t.timestamps
    end
    
    add_index :bibls, :barcode
    add_index :bibls, :call_number
    add_index :bibls, :catalog_key
    add_index :bibls, :pid
    add_index :bibls, :title
    add_index :bibls, :indexing_scenario_id
    add_index :bibls, :availability_policy_id
    add_index :bibls, :parent_bibl_id
    add_index :bibls, :use_right_id

    add_foreign_key :units, :bibls
    
  end
end
