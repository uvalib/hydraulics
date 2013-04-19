class HeardAboutService < ActiveRecord::Base
  has_many :customers
  has_many :orders, :through => :customers
  has_many :units, :through => :orders
  has_many :master_files, :through => :units

  scope :approved, where(:is_approved => true)
  scope :not_approved, where(:is_approved => false)
  scope :internal_use_only, where(:is_internal_use_only => true)
  scope :publicly_available, where(:is_internal_use_only => false)

  # Necessary for Active Admin to poplulate pulldown menu
  alias_attribute :name, :description
end