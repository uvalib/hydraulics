class Component < ActiveRecord::Base
  #------------------------------------------------------------------
  # relationships
  #------------------------------------------------------------------
  belongs_to :availability_policy, :counter_cache => true
  belongs_to :component_type, :counter_cache => true
  belongs_to :indexing_scenario, :counter_cache => true
  belongs_to :use_rights, :counter_cache => true
  
  has_many :automation_messages, :as => :messagable, :dependent => :destroy
  has_many :master_files
  has_many :image_master_files, :class_name => 'MasterFile', :conditions => "tech_meta_type = 'image'"

  has_and_belongs_to_many :bibls
  has_and_belongs_to_many :containers
  has_and_belongs_to_many :legacy_identifiers
 
  #------------------------------------------------------------------
  # validations
  #------------------------------------------------------------------
  validates :component_type, :presence => true
  validates :component_type, :presence => {
    :message => 'association with this ComponentType is no longer valid.'
  }
 
  #------------------------------------------------------------------
  # callbacks
  #------------------------------------------------------------------

  #------------------------------------------------------------------
  # scopes
  #------------------------------------------------------------------  
 
  #------------------------------------------------------------------
  # public class methods
  #------------------------------------------------------------------
 
  #------------------------------------------------------------------
  # public instance methods
  #------------------------------------------------------------------

end
