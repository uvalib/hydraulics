class Order < ActiveRecord::Base

  ORDER_STATUSES = %w[requested deferred canceled approved]

  #------------------------------------------------------------------
  # relationships
  #------------------------------------------------------------------
  belongs_to :agency, :counter_cache => true
  belongs_to :customer, :counter_cache => true, :inverse_of => :orders
  belongs_to :dvd_delivery_location, :counter_cache => true
  
  has_many :automation_messages, :as => :messagable, :dependent => :destroy
  has_many :bibls, :through => :units
  has_many :invoices, :dependent => :destroy
  has_many :master_files, :through => :units
  has_many :units, :inverse_of => :order
  has_many :heard_about_resources, :through => :units, :uniq => true

  has_one :academic_status, :through => :customer
  has_one :department, :through => :customer
  has_one :heard_about_service, :through => :customer
  has_one :primary_address, :through => :customer
  has_one :billable_address, :through => :customer

  #------------------------------------------------------------------
  # delegation
  #------------------------------------------------------------------
  delegate :full_name, :last_name, :first_name,
    :to => :customer, :allow_nil => true, :prefix => true
  delegate :name, 
    :to => :agency, :allow_nil => true, :prefix => true
  
  #------------------------------------------------------------------
  # scopes
  #------------------------------------------------------------------
  scope :complete, where("date_archiving_complete is not null")
  scope :deferred, where("order_status = 'deferred'")
  scope :in_process, where("date_archiving_complete is null").where("order_status = 'approved'")
  scope :awaiting_approval, where("order_status = 'requested'")
  scope :approved, where("order_status = 'approved'")
  scope :ready_for_delivery, where("`orders`.email IS NOT NULL and date_customer_notified IS NULL")
  scope :has_dvd_delivery, where("dvd_delivery_location_id IS NOT NULL")
  scope :recent, 
    lambda {|limit=5|
      order('date_request_submitted DESC').limit(limit)
    }
  default_scope :include => [:agency]
   
  #------------------------------------------------------------------
  # validations
  #------------------------------------------------------------------
  validates :date_due, :date_request_submitted, :presence => {
    :message => 'is required.'
  }
  validates_presence_of :customer

  # validates :agency, :presence => {
  #   :if => 'self.agency_id',
  #   :message => "association with this Agency is no longer valid because the Agency object no longer exists."
  # }
  validates :dvd_delivery_location, :presence => {
    :if => 'self.dvd_delivery_location_id',
    :message => "assocation with this DvdDeliveryLocation is no longer valid because the DvdDeliveryLocation object no longer exists."
  }
  validates :order_title, :uniqueness => true, :allow_blank => true
  
  validates :fee_estimated, :fee_actual, :numericality => {:greater_than_or_equal_to => 0, :allow_nil => true}

  validates :order_status, :inclusion => { :in => ORDER_STATUSES, 
    :message => 'must be one of these values: ' + ORDER_STATUSES.join(", ")}
            
  validates_datetime :date_request_submitted
  
  validates_date :date_due, :on => :update
  validates_date :date_due, :on => :create, :on_or_after => 28.days.from_now, :if => 'self.order_status == "requested"'
  
  validates_datetime :date_order_approved,
                    :date_deferred,
                    :date_canceled,
                    :date_permissions_given,
                    :date_started,
                    :date_archiving_complete,
                    :date_patron_deliverables_complete,
                    :date_customer_notified,
                    :date_finalization_begun,
                    :date_fee_estimate_sent_to_customer,
                    :allow_blank => true
                    
  # Validate data that could be coming in from the request form such that < and > are not
  # allowed in the text to prevent cross site scripting.
  validates :order_title, :entered_by, :special_instructions, :xss => true           
 
  #------------------------------------------------------------------
  # callbacks
  #------------------------------------------------------------------
  before_destroy :destroyable?
  
  before_save do
    # boolean fields cannot be NULL at database level
    self.is_approved = 0 if self.is_approved.nil? 
    self.is_approved = 1 if self.order_status == 'approved'
  end
  
  #------------------------------------------------------------------
  # scopes
  #------------------------------------------------------------------

  #------------------------------------------------------------------
  # aliases
  #------------------------------------------------------------------
  alias_attribute :name, :id
  
  #------------------------------------------------------------------
  # serializations
  #------------------------------------------------------------------
  # Email sent to customers should be save to DB as a TMail object.  During order delivery approval phase, the email
  # must be revisited when staff decide to send it.
  #serialize :email, TMail::Mail
  
  #------------------------------------------------------------------
  # public class methods
  #------------------------------------------------------------------
  # Returns a string containing a brief, general description of this
  # class/model.
  def Order.class_description
    return 'Order represents an order for digitization, placed by a Customer and made up of one or more Units.'
  end

  def Order.entered_by_description
    return "ID of person who filled out the public request form on behalf of the Customer."
  end
  
  #------------------------------------------------------------------
  # public instance methods
  #------------------------------------------------------------------
  # Returns a boolean value indicating whether the Order is active, which is
  # true unless the Order has been canceled or deferred.
  def active?
    if order_status == 'canceled' or order_status == 'deferred'
      return false
    else
      return true
    end
  end
  
  # Returns a boolean value indicating whether the Order is approved
  # for digitization ("order") or not ("request").
  def approved?
    if order_status == 'approved'
      return true
    else
      return false
    end
  end

  def canceled?
    if order_status == 'canceled'
      return true
    else
      return false
    end
  end

  # Returns a boolean value indicating whether it is safe to delete
  # this Order from the database. Returns +false+ if this record has
  # dependent records in other tables, namely associated Unit or
  # Invoice records.
  #
  # This method is public but is also called as a +before_destroy+ callback.
  def destroyable?               
    if units? || invoices?        
      return false 
    else
      return true
    end  
  end
  
  # Returns a boolean value indicating whether this Order has
  # associated Invoice records.
  def invoices?
    return invoices.any?
  end
  
  # Returns a boolean value indicating whether this Order has
  # associated Unit records.
  def units?
    return units.any?
  end

end
