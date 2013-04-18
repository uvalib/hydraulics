class IntendedUse < ActiveRecord::Base
  has_many :units, :dependent => :restrict

  validates :description, :presence => true

  scope :external_use, where(:is_internal_use_only => false)

  before_destroy :destroyable?
end