class CreateComponents < ActiveRecord::Migration
  def change
    create_table :components do |t|
      t.references :indexing_scenario, :component_type, :availability_policy

      t.integer :master_files_count, :default => 0
      t.timestamps
    end

    add_foreign_key :master_files, :components
    add_foreign_key :components, :availability_policies
        
    add_index :components, :availability_policy_id
    add_index :components, :component_type_id
    add_index :components, :indexing_scenario_id
    
  end
end
