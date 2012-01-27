class CreateComponents < ActiveRecord::Migration
  def change
    create_table :components do |t|
      t.references :indexing_scenario
      t.timestamps
    end
  end
end
