class CreateAcademicStatuses < ActiveRecord::Migration
  def change
    create_table :academic_statuses do |t|
      t.string :name
      t.timestamps
    end
  end
end
