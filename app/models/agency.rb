# Agency represents a project or organization associated with an Order.
class Agency < ActiveRecord::Base
  has_many :orders
  has_many :requests, :conditions => ['orders.order_status = ?', 'requested']
  has_many :units, :through => :orders
  has_many :master_files, :through => :units
  has_one :primary_address, :class_name => 'Address', :as => :addressable, :conditions => {:address_type => 'primary_address'}, :dependent => :destroy
  has_one :billable_address, :class_name => 'Address', :as => :addressable, :conditions => {:address_type => 'billable_address'}, :dependent => :destroy
  has_many :customers, :through => :orders, :uniq => true
  has_many :bibls, :through => :units, :uniq => true

  # Should be :case_sensitive => true, but might be a bug in 3.1-rc6
  validates :name, :presence => true, :uniqueness => {:case_sensitive => true} 
end