class Bibl < ActiveRecord::Base

  CREATOR_NAME_TYPES = %w[corporate personal]
  YEAR_TYPES = %w[copyright creation publication]
  GENRES = ['abstract or summary', 'art original', 'art reproduction', 'article', 'atlas', 'autobiography', 'bibliography', 'biography', 'book', 'catalog', 'chart', 'comic strip', 'conference publication', 'database', 'dictionary', 'diorama', 'directory', 'discography', 'drama', 'encyclopedia', 'essay', 'festschrift', 'fiction', 'filmography', 'filmstrip', 'finding aid', 'flash card', 'folktale', 'font', 'game', 'government publication', 'graphic', 'globe', 'handbook', 'history', 'hymnal', 'humor, satire', 'index', 'instruction', 'interview', 'issue', 'journal', 'kit', 'language instruction', 'law report or digest', 'legal article', 'legal case and case notes', 'legislation', 'letter', 'loose-leaf', 'map', 'memoir', 'microscope slide', 'model', 'motion picture', 'multivolume monograph', 'newspaper', 'novel', 'numeric data', 'offprint', 'online system or service', 'patent', 'periodical', 'picture', 'poetry', 'programmed text', 'realia', 'rehearsal', 'remote sensing image', 'reporting', 'review', 'script', 'series', 'short story', 'slide', 'sound', 'speech', 'statistics', 'survey of literature', 'technical drawing', 'technical report', 'thesis', 'toy', 'transparency', 'treaty', 'videorecording', 'web site']
  RESOURCE_TYPES = ['text', 'cartographic', 'notated music', 'sound recording', 'sound recording-musical', 'sound recording-nonmusical', 'still image', 'moving image', 'three dimensional object', 'software, multimedia', 'mixed material']

  #------------------------------------------------------------------
  # relationships
  #------------------------------------------------------------------
  belongs_to :availability_policy, :counter_cache => true
  belongs_to :indexing_scenario, :counter_cache => true
  belongs_to :use_right, :counter_cache => true
  
  has_and_belongs_to_many :legacy_identifiers
  has_and_belongs_to_many :components

  has_many :agencies, :through => :orders
  has_many :automation_messages, :as => :messagable, :dependent => :destroy
  has_many :customers, :through => :orders, :uniq => true
  has_many :master_files, :through => :units
  has_many :orders, :through => :units, :uniq => true
  has_many :units

  #------------------------------------------------------------------
  # scopes
  #------------------------------------------------------------------  
  scope :approved, where(:is_approved => true)
  scope :in_digital_library, where("bibls.date_dl_ingest is not null").order("bibls.date_dl_ingest DESC")
  scope :not_in_digital_library, where("bibls.date_dl_ingest is null")
  scope :not_approved, where(:is_approved => false)
  scope :has_exemplars, where("exemplar is NOT NULL")
  scope :need_exemplars, where("exemplar is NULL")

  #------------------------------------------------------------------
  # delegation
  #------------------------------------------------------------------
  # delegate :id, 
  #   :to => :unit, :allow_nil => true, :prefix => true

  # delegate :id, 
  #   :to => :order, :allow_nil => true, :prefix => true

  delegate :id, :email,
    :to => :customers, :allow_nil => true, :prefix => true

  #------------------------------------------------------------------
  # validations
  #------------------------------------------------------------------
  validates :availability_policy, :presence => {
    :if => 'self.availability_policy_id',
    :message => "association with this AvailabilityPolicy is no longer valid because it no longer exists."
  }
  validates :indexing_scenario, :presence => {
    :if => 'self.indexing_scenario_id',
    :message => "association with this IndexingScenario is no longer valid because it no longer exists."
  }
  
  #------------------------------------------------------------------
  # callbacks
  #------------------------------------------------------------------
  before_save do    
    # boolean fields cannot be NULL at database level
    self.is_approved = 0 if self.is_approved.nil?
    self.is_collection = 0 if self.is_collection.nil?
    self.is_in_catalog = 0 if self.is_in_catalog.nil?
    self.is_manuscript = 0 if self.is_manuscript.nil?
    self.is_personal_item = 0 if self.is_personal_item.nil?
    self.discoverability = 1 if self.discoverability.nil? # For Bibl objects, the default value is 1 (i.e. is discoverable)
    
    # get pid
    if self.pid.blank?
      begin
        self.pid = AssignPids.get_pid
      rescue Exception => e
        #ErrorMailer.deliver_notify_pid_failure(e) unless @skip_pid_notification
      end
    end

    # Moved from after_initialize in order to make compliant with 2.3.8
    if self.is_in_catalog.nil?
      # set default value
      if self.is_personal_item?
        self.is_in_catalog = false
      else
        # held by Library; default to assuming it's in Library catalog
        self.is_in_catalog = true
      end
    end
  end
  
  before_destroy :destroyable?
   
  #------------------------------------------------------------------
  # public class methods
  #------------------------------------------------------------------
 
  #------------------------------------------------------------------
  # public instance methods
  #------------------------------------------------------------------
  # Returns an array of Bibl objects that are the parent, grandparent, etc... of the 
  # Bibl object upon which this method is invoked.
  def ancestors
    parent_bibls = Array.new
    if parent_bibl_id != 0
      begin
        bibl = parent_bibl
        parent_bibls << bibl
        parent_bibls << bibl.ancestors unless bibl.ancestors.nil?
        return parent_bibls.flatten
      rescue ActiveRecord::RecordNotFound
        return parent_bibls.flatten
      end
    end
  end
  
  # Returns the array of Bibl objects for which this Bibl is parent.
  def child_bibls
    begin 
      return Bibl.find(:all, :conditions => "parent_bibl_id = #{id}")
    rescue ActiveRecord::RecordNotFound
      return Array.new
    end
  end
  
  def components?
    if components.any?
      return true
    else
      return false
    end  
  end
  
  # Returns an array of MasterFile objects (:id and :filename only) for the purposes 
  def dl_master_files
    if self.new_record?
      return Array.new
    else
      return MasterFile.joins(:bibl).joins(:unit).where('`units`.include_in_dl = true').where("`bibls`.id = #{self.id}")
    end
  end
    
  # Returns a boolean value indicating whether it is safe to delete this record
  # from the database. Returns +false+ if this record has dependent records in
  # other tables, namely associated Unit, Component, or EadRef records.
  #
  # This method is public but is also called as a +before_destroy+ callback.
  def destroyable?
    if components? || units?
      return false
    else
      return true
    end      
  end

  def in_catalog?
    return self.catalog_key?
  end

  def in_dl?
    return self.date_dl_ingest?
  end
      
  def master_file_filenames
    return master_files.map(&:filename) 
  end
  
  def parent_bibl
    begin
      return Bibl.find(parent_bibl_id)
    rescue ActiveRecord::RecordNotFound
      return nil
    end
  end

  def personal_item?
    return self.is_personal_item
  end
 
  def units?
    if units.any?
      return true
    else
      return false
    end  
  end
  
  #------------------------------------------------------------------
  # aliases
  #------------------------------------------------------------------
  alias :parent :parent_bibl
end
