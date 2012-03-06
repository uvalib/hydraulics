class MasterFile < ActiveRecord::Base

  #------------------------------------------------------------------
  # relationships
  #------------------------------------------------------------------
  belongs_to :availability_policy, :counter_cache => true
  belongs_to :component, :counter_cache => true
  belongs_to :indexing_scenario, :counter_cache => true
  belongs_to :unit, :counter_cache => true
  belongs_to :use_right, :counter_cache => true

  has_and_belongs_to_many :legacy_identifiers
  
  has_many :automation_messages, :as => :messagable, :dependent => :destroy

  has_one :image_tech_meta
  has_one :order, :through => :unit
  has_one :bibl, :through => :unit
  has_one :customer, :through => :order
  has_one :academic_status, :through => :customer

  #------------------------------------------------------------------
  # delegation
  #------------------------------------------------------------------
  delegate :call_number, :title, :catalog_key, :barcode, :id, :creator_name,
    :to => :bibl, :allow_nil => true, :prefix => true

  delegate :include_in_dl, :exclude_in_dl, :date_archived, :date_queued_for_ingest, :date_dl_deliverables_ready, :id,
    :to => :unit, :allow_nil => true, :prefix => true

  delegate :date_due, :date_order_approved, :date_request_submitted, :date_customer_notified, :id,
    :to => :order, :allow_nil => true, :prefix => true
    
  delegate :full_name, :id, :last_name, :first_name,
    :to => :customer, :allow_nil => true, :prefix => true

  delegate :name, 
    :to => :academic_status, :allow_nil => true, :prefix => true
  
  #------------------------------------------------------------------
  # validations
  #------------------------------------------------------------------  
  validates :filename, :unit_id, :title, :filesize, :presence => true
  validates :availability_policy, :presence => {
    :if => 'self.availability_policy_id',
    :message => "association with this AvailabilityPolicy is no longer valid because it no longer exists."
  }
  validates :component, :presence => {
    :if => 'self.component_id',
    :message => "association with this Component is no longer valid because it no longer exists."
  }
  validates :indexing_scenario, :presence => {
    :if => 'self.indexing_scenario_id',
    :message => "association with this IndexingScenario is no longer valid because it no longer exists."
  }
  validates :unit, :presence => {
    :message => "association with this Unit is no longer valid because it no longer exists."
  }
  validates :use_right, :presence => {
    :if => 'self.use_right_id',
    :message => "association with this Use is no longer valid because it no longer exists."
  }

  #------------------------------------------------------------------
  # callbacks
  #------------------------------------------------------------------
  after_create :increment_counter_caches

  after_destroy :decrement_counter_caches

  #------------------------------------------------------------------
  # scopes
  #------------------------------------------------------------------  
  scope :in_dl, where("date_dl_ingest is not null").order("date_dl_ingest ASC")
  # default_scope :include => [:availability_policy, :component, :indexing_scenario, :unit, :use_right]

  #------------------------------------------------------------------
  # public class methods
  #------------------------------------------------------------------
 
  #------------------------------------------------------------------
  # public instance methods
  #------------------------------------------------------------------
  def in_dl?
    return self.date_dl_ingest?
  end

  def name
    return self.filename
  end

  # Within the scope of a current MasterFile's Unit, return the MasterFile object
  # that follows self.  Used to create links and relationships between objects.
  def next
    master_files_sorted = self.unit.master_files.sort_by {|mf| mf.filename}
    if master_files_sorted.find_index(self) < master_files_sorted.length
      return master_files_sorted[master_files_sorted.find_index(self)+1]
    else
      return nil
    end
  end


  # Within the scope of a current MasterFile's Unit, return the MasterFile object
  # that preceedes self.  Used to create links and relationships between objects.
  def previous
    master_files_sorted = self.unit.master_files.sort_by {|mf| mf.filename}
    if master_files_sorted.find_index(self) > 0
      return master_files_sorted[master_files_sorted.find_index(self)-1]
    else
      return nil
    end
  end

  #------------------------------------------------------------------
  # private instance methods
  #------------------------------------------------------------------
  private

  def increment_counter_caches
    Bibl.increment_counter('master_files_count', self.bibl.id)
    Customer.increment_counter('master_files_count', self.customer.id)
    Order.increment_counter('master_files_count', self.order.id)
  end

  def decrement_counter_caches
    Bibl.decrement_counter('master_files_count', self.bibl.id)
    Customer.decrement_counter('master_files_count', self.customer.id)
    Order.decrement_counter('master_files_count', self.order.id)
  end
end
