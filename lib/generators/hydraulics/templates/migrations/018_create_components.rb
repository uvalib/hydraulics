class CreateComponents < ActiveRecord::Migration
  def change
    create_table :components do |t|

      t.timestamps
    end
  end
end
