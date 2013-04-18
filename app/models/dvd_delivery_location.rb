class DvdDeliveryLocation < ActiveRecord::Base
  has_many :orders, :dependent => :restrict

  validates :name, :email_desc, :presence => true, :uniqueness => {:case_sensitive => false}

  before_destroy :destroyable?
end