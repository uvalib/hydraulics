class CreateComponentTypes < ActiveRecord::Migration

  def change
    create_table :component_types do |t|
      t.string :name
      t.string :description
      t.timestamps
    end

    add_index :component_types, :name
    
    add_foreign_key :components, :component_types
  end
end