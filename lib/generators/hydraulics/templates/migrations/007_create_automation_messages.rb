class CreateAutomationMessages < ActiveRecord::Migration
  def change
    create_table :automation_messages do |t|
      t.integer :unit_id
      t.integer :order_id
      t.integer :master_file_id
      t.integer :bibl_id
      t.integer :component_id
      t.boolean :active_error, :null => false, :default => 0
      t.string :pid
      t.string :app
      t.string :processor
      t.string :message_type
      t.string :workflow_type
      t.text :message
      t.text :class_name
      t.text :backtrace
      t.timestamps
    end
    
    add_index :automation_messages, :unit_id
    add_index :automation_messages, :order_id
    add_index :automation_messages, :processor
    add_index :automation_messages, :message_type
    add_index :automation_messages, :workflow_type
    add_index :automation_messages, :active_error
    add_index :automation_messages, :master_file_id
    add_index :automation_messages, :bibl_id
    add_index :automation_messages, :component_id
  end
end