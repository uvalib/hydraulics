# Customer represents a person with Requests and/or Orders for digitization.
class Customer < ActiveRecord::Base
  belongs_to :academic_status, :counter_cache => true
  belongs_to :department, :counter_cache => true
  belongs_to :heard_about_service, :counter_cache => true
  
  has_many :orders, :inverse_of => :customer, :dependent => :restrict
  has_many :requests, :conditions => ['orders.order_status = ?', 'requested'], :inverse_of => :customer
  has_many :units, :through => :orders
  has_many :master_files, :through => :units
  has_many :bibls, :through => :units, :uniq => true
  has_many :invoices, :through => :orders
  has_many :agencies, :through => :orders, :uniq => true
  has_many :heard_about_resources, :through => :orders, :uniq => true
  
  has_one :primary_address, :class_name => 'Address', :as => :addressable, :conditions => {:address_type => 'primary'}, :dependent => :destroy, :autosave => true
  has_one :billable_address, :class_name => 'Address', :as => :addressable, :conditions => {:address_type => 'billable_address'}, :dependent => :destroy, :autosave => true

  accepts_nested_attributes_for :primary_address, :update_only => true
  accepts_nested_attributes_for :billable_address, :reject_if => :all_blank
  accepts_nested_attributes_for :orders

  delegate :organization,
    :to => :primary_address, :allow_nil => true, :prefix => true
  delegate :organization,
    :to => :billable_address, :allow_nil => true, :prefix => true

  validates :last_name, :first_name, :email, :presence => {
    :message => 'is required.'
  }
  validates :email, :uniqueness => true, :email => true # Email serves as a Customer object's unique identifier
  validates :last_name, :first_name, :person_name_format => true

  # Validating presence of continued association with valid external data
  validates :heard_about_service, 
            :presence => {
              :if => 'self.heard_about_service_id', 
              :message => "association with this Customer is no longer valid because the Heard About Service object does not exists."
            }    
          
  validates :academic_status, 
            :presence => {
              :if => 'self.academic_status_id', 
              :message => "association with this Customer is no longer valid because the Academic Status object does not exists."
            }    
  validates :department, 
            :presence => {
              :if => 'self.department_id', 
              :message => "association with this Customer is no longer valid because the Department object no longer exists."
            }

  default_scope :order => [:last_name, :first_name]

  before_destroy :destroyable?

  def orders?
    orders.any?
  end
   
  def requests?
   requests.any?
  end

  def full_name
    [first_name, last_name].join(' ')
  end

  alias_attribute :date_of_first_order, :created_at
end
