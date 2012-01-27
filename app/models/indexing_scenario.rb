class IndexingScenario < ActiveRecord::Base

  #------------------------------------------------------------------
  # relationships
  #------------------------------------------------------------------
  has_many :units
  has_many :master_files
  has_many :components
  has_many :bibls

  #------------------------------------------------------------------
  # validations
  #------------------------------------------------------------------
  validates :name, :pid, :repository_url, :datastream_name, :presence => true
  
  def complete_url
    return "#{self.repository_url}/fedora/objects/#{self.pid}/datastreams/#{self.datastream_name}/content"
  end

end
