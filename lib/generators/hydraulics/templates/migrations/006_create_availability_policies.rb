class CreateAvailabilityPolicies < ActiveRecord::Migration
  def change
    create_table :availability_policies do |t|
      t.string :name
      t.string :xacml_policy_url

      t.timestamps
    end

    add_foreign_key :bibls, :availability_policies
    add_foreign_key :units, :availability_policies
    add_foreign_key :master_files, :availability_policies
  end
end