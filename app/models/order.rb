class Order < ActiveRecord::Base
  ORDER_STATUSES = %w[requested deferred canceled approved]

  belongs_to :agency, :counter_cache => true
  belongs_to :customer, :counter_cache => true, :inverse_of => :orders
  belongs_to :dvd_delivery_location, :counter_cache => true
  
  has_many :automation_messages, :as => :messagable, :dependent => :destroy
  has_many :bibls, :through => :units
  has_many :invoices, :dependent => :destroy
  has_many :master_files, :through => :units
  has_many :units, :inverse_of => :order, :dependent => :restrict
  has_many :heard_about_resources, :through => :units, :uniq => true

  has_one :academic_status, :through => :customer
  has_one :department, :through => :customer
  has_one :heard_about_service, :through => :customer
  has_one :primary_address, :through => :customer
  has_one :billable_address, :through => :customer

  delegate :full_name, :last_name, :first_name,
    :to => :customer, :allow_nil => true, :prefix => true
  delegate :name, 
    :to => :agency, :allow_nil => true, :prefix => true

  scope :complete, where("date_archiving_complete is not null")
  scope :deferred, where("order_status = 'deferred'")
  scope :in_process, where("date_archiving_complete is null").where("order_status = 'approved'")
  scope :awaiting_approval, where("order_status = 'requested'")
  scope :approved, where("order_status = 'approved'")
  scope :ready_for_delivery, where("`orders`.email is not null").where(:date_customer_notified => nil)
  scope :has_dvd_delivery, where("dvd_delivery_location_id IS NOT NULL")
  scope :recent, 
    lambda {|limit=5|
      order('date_request_submitted DESC').limit(limit)
    }
  scope :unpaid, where("fee_actual > 0").joins(:invoices).where('`invoices`.date_fee_paid IS NULL').where('`invoices`.permanent_nonpayment IS false').where('`orders`.date_customer_notified > ?', 2.year.ago).order('fee_actual desc')
  default_scope :include => [:agency]

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

  # validates that an order_status cannot equal approved if any of it's Units.unit_status != "approved" || "canceled"
  validate :validate_order_approval
                    
  # Validate data that could be coming in from the request form such that < and > are not
  # allowed in the text to prevent cross site scripting.
  validates :order_title, :entered_by, :special_instructions, :xss => true           
 
  before_destroy :destroyable?

  alias_attribute :name, :id

  # Returns a boolean value indicating whether the Order is active, which is
  # true unless the Order has been canceled or deferred.
  def active?
    # order_status != 'canceled' && order_status != 'deferred'
    ['requested', 'approved'].include?(order_status)
  end

  # Returns units belonging to current order that are not ready to proceed with digitization and would prevent an order from being approved.
  # Only units whose unit_status = 'approved' or 'canceled' are removed from consideration by this method.
  # def has_units_being_prepared
    
  # end

  # A validation callback which returns to the Order#edit view the IDs of Units which are preventing the Order from being approved because they 
  # are neither approved or canceled.
  def validate_order_approval
    if order_status == 'approved' && !new_record?  && units.where('unit_status = ? or unit_status = ? or unit_status = ?', "unapproved", "condition", "copyright").any?
      errors[:order_status] << "cannot be set to approved because several units are neither approved nor canceled."
    end
  end
end