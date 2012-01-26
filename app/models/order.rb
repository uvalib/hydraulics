# == Schema Information
#
# Table name: orders
#
#  id                                 :integer         not null, primary key
#  agency_id                          :integer
#  customer_id                        :integer         default(0), not null
#  dvd_delivery_location_id           :integer
#  units_count                        :integer         default(0)
#  invoices_count                     :integer         default(0)
#  automation_messages_count          :integer         default(0)
#  date_canceled                      :datetime
#  date_deferred                      :datetime
#  date_due                           :date
#  date_fee_estimate_sent_to_customer :datetime
#  date_order_approved                :datetime
#  date_permissions_given             :datetime
#  date_started                       :datetime
#  date_request_submitted             :datetime
#  entered_by                         :string(255)
#  fee_actual                         :decimal(7, 2)
#  fee_estimated                      :decimal(7, 2)
#  is_approved                        :boolean         default(FALSE), not null
#  order_status                       :string(255)
#  order_title                        :string(255)
#  special_instructions               :text
#  staff_notes                        :text
#  date_archiving_complete            :datetime
#  date_customer_notified             :datetime
#  date_finalization_begun            :datetime
#  date_patron_deliverables_complete  :datetime
#  email                              :text
#  created_at                         :datetime
#  updated_at                         :datetime
#

class Order < ActiveRecord::Base

  ORDER_STATUSES = %w[requested deferred canceled approved]

  #------------------------------------------------------------------
  # relationships
  #------------------------------------------------------------------
  belongs_to :agency, :counter_cache => true
  belongs_to :customer, :counter_cache => true
  # belongs_to :dvd_delivery_location
  
  has_many :automation_messages
  has_many :bibls, :through => :units
  has_many :invoices
  has_many :master_files, :through => :units
  # has_many :master_files_in_dl,
  #          :class_name => "MasterFile",
  #          :conditions => { :d => true }
  has_many :units

  #------------------------------------------------------------------
  # delegation
  #------------------------------------------------------------------
  delegate :full_name, 
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
  scope :recent, 
    lambda {|limit=5|
      order('date_request_submitted DESC').limit(limit)
    }
  default_scope :include => [:agency]
   
  #------------------------------------------------------------------
  # validations
  #------------------------------------------------------------------
  validates :customer_id, 
            :date_request_submitted, 
            :date_due, 
            :presence => true
            
  validates :customer, 
            :presence => {
              :message => "association with this Customer is no longer valid because the Customer object no longer exists."
            }
  validates :agency, 
            :presence => {
              :if => 'self.agency_id',
              :message => "association with this Agency is no longer valid because the Agency object no longer exists."
            }

  validates :order_title, :uniqueness => true
  validates :fee_estimated, 
            :fee_actual, 
            :numericality => {:greater_than => 0, :allow_nil => true}

  validates :order_status, :inclusion => { :in => ORDER_STATUSES, 
    :message => 'must be one of these values: ' + ORDER_STATUSES.join(", ")}
            
  validates_datetime :date_request_submitted
  
  validates_date :date_due
  
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
                    :allow_nil => true
                    
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
  end
  
  #------------------------------------------------------------------
  # scopes
  #------------------------------------------------------------------
  
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
  
  # Returns a boolean value indicating whether it is safe to delete
  # this Order from the database. Returns +false+ if this record has
  # dependent records in other tables, namely associated Unit or
  # Invoice records.
  #
  # This method is public but is also called as a +before_destroy+ callback.
  def destroyable?
    if not units? or not invoices?
      return false
    end
    return true
  end
  
  # Returns a boolean value indicating whether this Order has
  # associated Invoice records.
  def invoices?
    return invoices.any?
  end

  # Order must return a name for identification purposes
  def name
    return id
  end
  
  # Returns this object's parent object.
  # def parent
  #     return self.customer
  #   end
  
  # Returns a boolean value indicating whether this Order has
  # associated Unit records.
  def units?
    return units.any?
  end

end
