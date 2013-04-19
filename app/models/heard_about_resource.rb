class HeardAboutResource < ActiveRecord::Base
  has_many :units
  has_many :master_files, :through => :units
  has_many :orders, :through => :units
  has_many :customers, :through => :orders

  scope :approved, where(:is_approved => true)
  scope :not_approved, where(:is_approved => false)
  scope :internal_use_only, where(:is_internal_use_only => true)
  scope :publicly_available, where(:is_internal_use_only => false)
end