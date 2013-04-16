class CreateSqlReports < ActiveRecord::Migration
  def change
    create_table :sql_reports do |t|
      t.string :name
      t.string :description
      t.text :sql
      t.timestamps
    end
  end
end
