class AcademicStatus < ActiveRecord::Base
  has_many :customers
  has_many :orders, :through => :customers
  has_many :requests, :through => :customers, :conditions => ['orders.order_status = ?', 'requested']
  has_many :units, :through => :orders
  has_many :master_files, :through => :units

  validates :name, :presence => true
end