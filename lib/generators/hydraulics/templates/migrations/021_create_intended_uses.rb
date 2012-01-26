class CreateIntendedUses < ActiveRecord::Migration
  def change
    create_table :intended_uses do |t|
      t.string :description
      t.boolean :is_internal_use_only
      t.boolean :is_approved
      t.timestamps
    end
  end
end
