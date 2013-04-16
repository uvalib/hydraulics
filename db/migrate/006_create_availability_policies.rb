class CreateAvailabilityPolicies < ActiveRecord::Migration
  def change
    create_table :availability_policies do |t|
      t.string :name
      t.string :xacml_policy_url
      t.integer :bibls_count, :default => 0
      t.integer :components_count, :default => 0
      t.integer :master_files_count, :default => 0
      t.integer :units_count, :default => 0

      t.timestamps
    end

    add_foreign_key :bibls, :availability_policies
    add_foreign_key :master_files, :availability_policies
    add_foreign_key :units, :availability_policies

  end
end