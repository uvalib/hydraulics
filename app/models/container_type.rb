class ContainerType < ActiveRecord::Base

  has_many :containers

  validates :name, :presence => true

end