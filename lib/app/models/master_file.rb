# == Schema Information
#
# Table name: master_files
#
#  id                        :integer         not null, primary key
#  availability_policy_id    :integer
#  component_id              :integer
#  ead_ref_id                :integer
#  tech_meta_type            :string(255)
#  unit_id                   :integer         default(0), not null
#  use_right_id              :integer
#  automation_messages_count :integer
#  description               :string(255)
#  filename                  :string(255)
#  filesize                  :integer
#  md5                       :string(255)
#  title                     :string(255)
#  dc                        :text
#  desc_metadata             :text
#  discoverability           :boolean         default(FALSE), not null
#  locked_desc_metadata      :boolean         default(FALSE), not null
#  pid                       :string(255)
#  rels_ext                  :text
#  rels_int                  :text
#  solr                      :text(16777215)
#  transcription_text        :text
#  date_ingested_into_dl     :datetime
#  created_at                :datetime
#  updated_at                :datetime
#

class MasterFile < ActiveRecord::Base

  #------------------------------------------------------------------
  # relationships
  #------------------------------------------------------------------
  belongs_to :unit, :counter_cache => true
#  belongs_to :component
  
 # has_and_belongs_to_many :ead_refs
  has_many :automation_messages
#  has_one :audio_tech_meta
  has_one :image_tech_meta
#  has_one :video_tech_meta
  has_one :order, :through => :unit
  has_one :bibl, :through => :unit
  has_one :customer, :through => :order

  #------------------------------------------------------------------
  # delegation
  #------------------------------------------------------------------
  delegate :call_number, :title, :catalog_key, :barcode, :id,
    :to => :bibl, :allow_nil => true, :prefix => true

  delegate :include_in_dl, :exclude_in_dl, :date_archived, :date_queued_for_ingest, :date_dl_deliverables_ready,
    :to => :unit, :allow_nil => true, :prefix => true

  delegate :date_due, :date_order_approved, :date_request_submitted, :date_customer_notified, :id,
    :to => :order, :allow_nil => true, :prefix => true
    
  delegate :full_name,
    :to => :customer, :allow_nil => true, :prefix => true
  
  #------------------------------------------------------------------
  # validations
  #------------------------------------------------------------------  
  # validates :filename, :unit_id, :title, :filesize, :presence => true

  #------------------------------------------------------------------
  # callbacks
  #------------------------------------------------------------------
  before_save do
    self.discoverability = 0 if self.discoverability.nil?
    self.locked_desc_metadata = 0 if self.locked_desc_metadata.nil?  
  end
  
  before_destroy do
    
  end

  #------------------------------------------------------------------
  # scopes
  #------------------------------------------------------------------  
  scope :in_dl, where("date_ingested_into_dl is not null").order("date_ingested_into_dl ASC")

  #------------------------------------------------------------------
  # public class methods
  #------------------------------------------------------------------
 
  #------------------------------------------------------------------
  # public instance methods
  #------------------------------------------------------------------
  def in_dl?
    return self.date_ingested_into_dl?
  end

  def name
    return self.filename
  end

end
