class CreateIndexingScenarios < ActiveRecord::Migration
  def change
    create_table :indexing_scenarios do |t|
      t.string :name
      t.string :pid
      t.string :datastream_name
      t.string :repository_url
      t.timestamps
    end

    add_foreign_key :bibls, :indexing_scenarios
    add_foreign_key :components, :indexing_scenarios
    add_foreign_key :master_files, :indexing_scenarios
    add_foreign_key :units, :indexing_scenarios
  end
end
