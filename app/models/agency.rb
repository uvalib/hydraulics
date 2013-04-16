class Agency < ActiveRecord::Base
  
  #------------------------------------------------------------------
  # relationships
  #------------------------------------------------------------------ 
  has_many :orders
  has_many :requests, :conditions => ['orders.order_status = ?', 'requested']
  has_many :units, :through => :orders
  has_many :master_files, :through => :units
  has_one :primary_address, :class_name => 'Address', :as => :addressable, :conditions => {:address_type => 'primary_address'}, :dependent => :destroy
  has_one :billable_address, :class_name => 'Address', :as => :addressable, :conditions => {:address_type => 'billable_address'}, :dependent => :destroy
  has_many :customers, :through => :orders, :uniq => true
  has_many :bibls, :through => :units, :uniq => true
 
  #------------------------------------------------------------------
  # validations
  #------------------------------------------------------------------
  # Should be :case_sensitive => true, but might be a bug in 3.1-rc6
  validates :name, :presence => true, :uniqueness => true 
 
  #------------------------------------------------------------------
  # callbacks
  #------------------------------------------------------------------
  before_save do 
    self.is_billable = 0 if self.is_billable.nil?
  end
  
  #------------------------------------------------------------------
  # scopes
  #------------------------------------------------------------------

  #------------------------------------------------------------------
  # public class methods
  #------------------------------------------------------------------
  # Returns a string containing a brief, general description of this
  # class/model.
  def Agency.class_description
    return 'Agency represents a project or organization associated with an Order.'
  end
  
  # Returns a boolean value indicating whether this Customer has
  # associated Order records.
  def orders?
    orders.any?
  end
   
  # Returns a boolean value indicating whether this Customer has
  # associated Request (unapproved Order) records.
  def requests?
    requests.any?
  end
end
