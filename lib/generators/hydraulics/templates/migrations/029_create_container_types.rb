class CreateContainerTypes < ActiveRecord::Migration
  def change
    create_table :container_types do |t|
      t.string :name
      t.string :description
    end

    add_index :containers, :name, :unique => true
    add_foreign_key :containers, :container_types
  end
end
