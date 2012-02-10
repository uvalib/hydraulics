class CreateUseRights < ActiveRecord::Migration

  def change
    create_table :use_rights do |t|
      t.string :name
      t.string :description
      t.timestamps
    end

    add_index :use_rights, :name, :unique => true

    add_foreign_key :units, :use_rights
  end
end