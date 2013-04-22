class Component < ActiveRecord::Base
  include Pidable
  include Workflowable

  belongs_to :component_type, :counter_cache => true

  has_many :master_files
  has_many :image_master_files, :class_name => 'MasterFile', :conditions => "tech_meta_type = 'image'"

  has_and_belongs_to_many :bibls
  has_and_belongs_to_many :containers

  validates :component_type, :presence => true
  validates :component_type, :presence => {
    :message => 'association with this ComponentType is no longer valid.'
  }
end
