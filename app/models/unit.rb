class Unit < ActiveRecord::Base
  include Workflowable

  UNIT_STATUSES = %w[approved canceled condition copyright unapproved]

  belongs_to :archive, :counter_cache => true
  belongs_to :availability_policy, :counter_cache => true
  belongs_to :bibl, :counter_cache => true
  belongs_to :heard_about_resource, :counter_cache => true
  belongs_to :intended_use, :counter_cache => true
  belongs_to :indexing_scenario, :counter_cache => true
  belongs_to :order, :counter_cache => true, :inverse_of => :units
  belongs_to :use_right, :counter_cache => true

  has_many :master_files
  has_many :components, :through => :master_files, :uniq => true

  has_one :agency, :through => :order
  has_one :customer, :through => :order

  delegate :call_number, :title, :catalog_key, :barcode, :pid, :exemplar,
    :to => :bibl, :allow_nil => true, :prefix => true
  delegate :id, :full_name,
    :to => :customer, :allow_nil => true, :prefix => true
  delegate :date_due,
    :to => :order, :allow_nil => true, :prefix => true
  delegate :deliverable_format, :deliverable_resolution, :deliverable_resolution_unit,
    :to => :intended_use, :allow_nil => true, :prefix => true

  scope :in_repo, where("date_dl_deliverables_ready IS NOT NULL").order("date_dl_deliverables_ready DESC")
  scope :ready_for_repo, where(:include_in_dl => true).where("`units`.availability_policy_id IS NOT NULL").where(:date_queued_for_ingest => nil).where("date_archived is not null")
  scope :checkedout_materials, where("date_materials_received IS NOT NULL AND date_materials_returned IS NULL")
  scope :overdue_materials, where("date_materials_received IS NOT NULL AND date_archived IS NOT NULL AND date_materials_returned IS NULL")
  scope :awaiting_copyright_approval, where(:unit_status => 'copyright')
  scope :awaiting_condition_approval, where(:unit_status => 'condition')
  scope :approved, where(:unit_status => 'approved')
  scope :unapproved, where(:unit_status => 'unapproved')
  scope :canceled, where(:unit_status => 'canceled')

  validates_presence_of :order
  validates :patron_source_url, :format => {:with => URI::regexp(['http','https'])}, :allow_blank => true
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
     :message => "must be selected."
  }
  validates :indexing_scenario, :presence => {
    :if => 'self.indexing_scenario_id',
    :message => "association with this IndexingScenario is no longer valid because it no longer exists."
  }
  validates :order, :presence => {
    :if => 'self.order_id',
    :message => "association with this Order is no longer valid because it no longer exists."
  }
  validates :use_right, :presence => {
    :if => 'self.use_right_id',
    :message => "association with this UseRight is no longer valid because it no longer exists."
  }

  before_save do
    self.unit_status = "unapproved" if self.unit_status.nil? || self.unit_status.empty?
  end

  # Necessary for Active Admin to poplulate pulldown menu
  alias_attribute :name, :id

  def approved?
    unit_status == "approved"
  end

  def canceled?
    unit_status == "canceled"
  end

  def in_dl?
    self.date_dl_deliverables_ready?
  end

  def ready_for_repo?
    if self.include_in_dl == true and not self.availability_policy_id.nil? and self.date_queued_for_ingest.nil? and not self.date_archived.nil?
      return true
    else
      return false
    end
  end
end
