class MasterFile < ActiveRecord::Base
  include Pidable
  include Workflowable

  belongs_to :component, :counter_cache => true
  belongs_to :unit, :counter_cache => true

  has_one :image_tech_meta, :dependent => :destroy
  has_one :order, :through => :unit
  has_one :bibl, :through => :unit
  has_one :customer, :through => :order
  has_one :academic_status, :through => :customer
  has_one :department, :through => :customer
  has_one :agency, :through => :order
  has_one :archive, :through => :unit
  has_one :heard_about_resource, :through => :unit
  has_one :heard_about_service, :through => :customer

  delegate :call_number, :title, :catalog_key, :barcode, :id, :creator_name, :year,
    :to => :bibl, :allow_nil => true, :prefix => true

  delegate :include_in_dl, :exclude_in_dl, :date_archived, :date_queued_for_ingest, :date_dl_deliverables_ready,
    :to => :unit, :allow_nil => true, :prefix => true

  delegate :date_due, :date_order_approved, :date_request_submitted, :date_customer_notified, :id,
    :to => :order, :allow_nil => true, :prefix => true

  delegate :full_name, :id, :last_name, :first_name,
    :to => :customer, :allow_nil => true, :prefix => true

  delegate :name,
    :to => :academic_status, :allow_nil => true, :prefix => true

  delegate :name,
    :to => :agency, :allow_nil => true, :prefix => true

  validates :filename, :unit_id, :filesize, :presence => true
  validates :component, :presence => {
    :if => 'self.component_id',
    :message => "association with this Component is no longer valid because it no longer exists."
  }
  validates :unit, :presence => {
    :message => "association with this Unit is no longer valid because it no longer exists."
  }

  after_create :increment_counter_caches
  after_destroy :decrement_counter_caches

  private

  def increment_counter_caches
    # Conditionalize Bibl increment because it is not required.
    # Bibl.increment_counter('master_files_count', self.bibl.id) if self.bibl
    Customer.increment_counter('master_files_count', self.customer.id)
    Order.increment_counter('master_files_count', self.order.id)
  end

  def decrement_counter_caches
    # Conditionalize Bibl decrement because it is not required.
    # Bibl.decrement_counter('master_files_count', self.bibl.id) if self.bibl
    Customer.decrement_counter('master_files_count', self.customer.id)
    Order.decrement_counter('master_files_count', self.order.id)
  end
end
