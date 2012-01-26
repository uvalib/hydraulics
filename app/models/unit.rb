# == Schema Information
#
# Table name: units
#
#  id                             :integer         not null, primary key
#  archive_id                     :integer
#  availability_policy_id         :integer
#  bibl_id                        :integer
#  heard_about_resource_id        :integer
#  intended_use_id                :integer
#  order_id                       :integer         default(0), not null
#  use_right_id                   :integer
#  master_files_count             :integer         default(0)
#  automation_messages_count      :integer         default(0)
#  date_archived                  :datetime
#  date_materials_received        :datetime
#  date_materials_returned        :datetime
#  date_patron_deliverables_ready :datetime
#  deliverable_format             :string(255)
#  deliverable_resolution         :string(255)
#  deliverable_resolution_unit    :string(255)
#  patron_source_url              :string(255)
#  remove_watermark               :boolean         default(FALSE), not null
#  special_instructions           :text
#  staff_notes                    :text
#  unit_extent_estimated          :integer
#  unit_extent_actual             :integer
#  unit_status                    :string(255)
#  date_queued_for_ingest         :datetime
#  date_dl_deliverables_ready     :datetime
#  master_file_discoverability    :boolean         default(FALSE), not null
#  exclude_from_dl                :boolean         default(FALSE), not null
#  include_in_dl                  :boolean         default(FALSE), not null
#  created_at                     :datetime
#  updated_at                     :datetime
#

class Unit < ActiveRecord::Base
  #------------------------------------------------------------------
  # relationships
  #------------------------------------------------------------------
  belongs_to :bibl, :counter_cache => true
  belongs_to :order, :counter_cache => true
  belongs_to :heard_about_resource
  belongs_to :intended_use

  has_many :master_files
  has_many :automation_messages

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
