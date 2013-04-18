class Archive < ActiveRecord::Base
  has_many :units, :dependent => :restrict
  has_many :master_files, :through => :units

  validates :name, :presence => true, :uniqueness => {:case_sensitive => false} # 'HSM' and 'Hsm' should be considered the same.

  before_destroy :destroyable?
end