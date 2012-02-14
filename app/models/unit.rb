class Unit < ActiveRecord::Base
  #------------------------------------------------------------------
  # relationships
  #------------------------------------------------------------------
  belongs_to :archive, :counter_cache => true
  belongs_to :availability_policy, :counter_cache => true
  belongs_to :bibl, :counter_cache => true
  belongs_to :heard_about_resource, :counter_cache => true
  belongs_to :intended_use, :counter_cache => true
  belongs_to :indexing_scenario, :counter_cache => true
  belongs_to :order, :counter_cache => true
  belongs_to :use_right, :counter_cache => true

  has_many :master_files
  has_many :automation_messages

  has_one :agency, :through => :order
  has_one :customer, :through => :order

  delegate :call_number, :title, :catalog_key, :barcode, :pid,
    :to => :bibl, :allow_nil => true, :prefix => true
  delegate :full_name, 
    :to => :customer, :allow_nil => true, :prefix => true
  delegate :date_due, 
    :to => :order, :allow_nil => true, :prefix => true

  #------------------------------------------------------------------
  # scopes
  #------------------------------------------------------------------  
  scope :in_repo, where("date_dl_deliverables_ready IS NOT NULL").order("date_dl_deliverables_ready DESC")
  scope :ready_for_repo, where("include_in_dl IS NOT NULL AND availability_policy_id IS NOT NULL AND date_queued_for_ingest IS NULL")
  default_scope :include => [:bibl, :intended_use]

  #------------------------------------------------------------------
  # validations
  #------------------------------------------------------------------
  validates :intended_use_id, :order_id, :presence => true
  validates :patron_source_url, :format => {:with => URI::regexp(['http','https'])}
  validates :archive, :presence => {
    :if => 'self.archive_id',
    :message => "association with this Archive is no longer valid because it no longer exists."
  }
  validates :availability_policy, :presence => {
    :if => 'self.availability_policy_id',
    :message => "association with this AvailabilityPolicy is no longer valid because it no longer exists."
  }
  validates :bibl, :presence => {
    :if => 'self.bibl_id',
    :message => "association with this Bibl is no longer valid because it no longer exists."
  }
  validates :heard_about_resource, :presence => {
    :if => 'self.heard_about_resource_id',
    :message => "association with this HeardAboutResource is no longer valid because it no longer exists."
  }
  validates :intended_use, :presence => {
     :message => "association with this IntendedUse is no longer valid because it no longer exists."
  }
  validates :indexing_scenario, :presence => {
    :if => 'self.indexing_scenario_id',
    :message => "association with this IndexingScenario is no longer valid because it no longer exists."
  }
  validates :order, :presence => {
    :message => "association with this Order is no longer valid because it no longer exists."
  }
  validates :use_right, :presence => {
    :if => 'self.use_right_id',
    :message => "association with this UseRight is no longer valid because it no longer exists."
  }
 
  #------------------------------------------------------------------
  # callbacks
  #------------------------------------------------------------------
  before_save do 
    # boolean fields cannot be NULL at database level
    self.exclude_from_dl = 0 if self.exclude_from_dl.nil?
    self.include_in_dl = 0 if self.include_in_dl.nil?
    self.master_file_discoverability = 0 if self.master_file_discoverability.nil?
    self.order_id = 0 if self.order_id.nil?
    self.remove_watermark = 0 if self.remove_watermark.nil?
  end

  #------------------------------------------------------------------
  # aliases
  #------------------------------------------------------------------
  # Necessary for Active Admin to poplulate pulldown menu
  alias_attribute :name, :id

  #------------------------------------------------------------------
  # public class methods
  #------------------------------------------------------------------
 
  #------------------------------------------------------------------
  # public instance methods
  #------------------------------------------------------------------
  def in_dl?
    return self.date_dl_deliverables_ready?
  end
end
