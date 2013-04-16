class CreateImageTechMeta < ActiveRecord::Migration
  def change
    create_table :image_tech_meta do |t|
      t.integer :master_file_id, :default => 0, :null => false
      t.string :image_format
      t.integer :width
      t.integer :height
      t.integer :resolution
      t.string :color_space
      t.integer :depth
      t.string :compression
      t.string :color_profile
      t.string :equipment
      t.string :software
      t.string :model
      t.string :exif_version
      t.datetime :capture_date
      t.integer :iso
      t.string :exposure_bias
      t.string :exposure_time
      t.string :aperture
      t.decimal :focal_length
      t.timestamps
    end

    add_index :image_tech_meta, :master_file_id
    add_foreign_key :image_tech_meta, :master_files
  end
end