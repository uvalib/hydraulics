class CreateContainers < ActiveRecord::Migration
  def change
    create_table :containers do |t|
      t.string :barcode
      t.integer :container_type_id
      t.string :label
      t.string :sequence_no
      t.integer :parent_container_id, :null => false, :default => 0, :references => nil
      t.timestamps
    end

    add_index :containers, :parent_container_id
    add_index :containers, :container_type_id

    create_table :components_containers do |t|
      t.integer :component_id
      t.integer :container_id
    end

    add_index :components_containers, :component_id
    add_index :components_containers, :container_id
    add_foreign_key :components_containers, :components
    add_foreign_key :components_containers, :containers

  end
end
