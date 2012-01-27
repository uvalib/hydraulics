class CreateIndexingScenarios < ActiveRecord::Migration
  def change
    create_table :indexing_scenarios do |t|
      t.string :name
      t.string :pid
      t.string :datastream_name
      t.string :repository_url
      t.timestamps
    end
  end
end
