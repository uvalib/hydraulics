class CreateComponents < ActiveRecord::Migration
  def change
    create_table :components do |t|
      t.references :indexing_scenario, :component_type
      t.timestamps
    end

    add_foreign_key :master_files, :components
    add_index :components, :component_type_id
    add_index :components, :indexing_scenario_id
    
  end
end
