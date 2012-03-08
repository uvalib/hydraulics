class Agency < ActiveRecord::Base
  
  #------------------------------------------------------------------
  # relationships
  #------------------------------------------------------------------ 
  has_many :orders, :class_name => 'Order', :conditions => ['is_approved = ?', true]
  has_many :requests, :class_name => 'Order', :conditions => ['is_approved = ?', false]
  has_many :units, :through => :orders
  has_many :master_files, :through => :units
  has_one :primary_address, :class_name => 'Address', :as => :addressable, :conditions => {:address_type => 'primary_address'}, :dependent => :destroy
  has_one :billable_address, :class_name => 'Address', :as => :addressable, :conditions => {:address_type => 'billable_address'}, :dependent => :destroy
 
  #------------------------------------------------------------------
  # validations
  #------------------------------------------------------------------
  # Should be :case_sensitive => true, but might be a bug in 3.1-rc6
  validates :name, :presence => true, :uniqueness => true 

  before_destroy :destroyable?
  
  #------------------------------------------------------------------
  # callbacks
  #------------------------------------------------------------------
  before_save do 
    self.is_billable = 0 if self.is_billable.nil?
  end
  
  #------------------------------------------------------------------
  # scopes
  #------------------------------------------------------------------
  default_scope :order => :name

  #------------------------------------------------------------------
  # public class methods
  #------------------------------------------------------------------
  # Returns a string containing a brief, general description of this
  # class/model.
  def Agency.class_description
    return 'Agency represents a project or organization associated with an Order.'
  end
  
  #------------------------------------------------------------------
  # public instance methods
  #------------------------------------------------------------------
  # Returns a boolean value indicating whether it is safe to delete this
  # Customer from the database. Returns +false+ if this record has dependent
  # records in other tables, namely associated Order records. (We do not check
  # for a BillingAddress record, because it is considered merely an extension of
  # the Customer record; it gets destroyed when the Customer is destroyed.)
  #
  # This method is public but is also called as a +before_destroy+ callback.
  # def destroyable?  
  def destroyable?
    if not orders? and not requests?
      return false
    else
      return true
    end
  end
  
  # Returns a boolean value indicating whether this Customer has
  # associated Order records.
  def orders?
   return false unless orders.any?
  end
   
  # Returns a boolean value indicating whether this Customer has
  # associated Request (unapproved Order) records.
  def requests?
   return false unless requests.any?
  end
end
