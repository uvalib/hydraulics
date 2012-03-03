class CreateAutomationMessages < ActiveRecord::Migration
  def change
    create_table :automation_messages do |t|

      # Custom polymorphism
      t.integer :messagable_id, :null => false
      t.integer :messagable_type, :null => false, :limit => 20

      t.boolean :active_error, :null => false, :default => 0
      t.string :app, :limit => 20
      t.string :processor, :limit => 50
      t.string :message_type, :limit => 20
      t.string :message
      t.string :class_name, :limit => 50
      t.text :backtrace
      t.string :workflow_type, :limit => 20
      t.timestamps
    end
    
    add_index :automation_messages, [:messagable_id, :messagable_type]
    add_index :automation_messages, :processor
    add_index :automation_messages, :message_type
    add_index :automation_messages, :workflow_type
    add_index :automation_messages, :active_error
  end
end