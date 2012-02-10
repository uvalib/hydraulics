class CreateIntendedUses < ActiveRecord::Migration
  def change
    create_table :intended_uses do |t|
      t.string :description
      t.boolean :is_internal_use_only, :default => false, :null => false
      t.boolean :is_approved, :default => false, :null => false
      t.timestamps
    end

    add_index :intended_uses, :description, :unique => true

    add_foreign_key :units, :intended_uses
  end
end
