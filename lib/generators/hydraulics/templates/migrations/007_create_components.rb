class CreateComponents < ActiveRecord::Migration
  def change
    create_table :components do |t|
      t.references :indexing_scenario
      t.timestamps
    end

    add_foreign_key :master_files, :components
    
  end
end
