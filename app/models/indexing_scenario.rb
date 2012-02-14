class IndexingScenario < ActiveRecord::Base

  #------------------------------------------------------------------
  # relationships
  #------------------------------------------------------------------
  has_many :bibls
  has_many :components
  has_many :master_files
  has_many :units

  #------------------------------------------------------------------
  # validations
  #------------------------------------------------------------------
  validates :name, :pid, :repository_url, :datastream_name, :presence => true
  validates :name, :pid, :uniqueness => true
  validates :repository_url, :format => {:with => URI::regexp(['http','https'])}
 
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
  def complete_url
    return "#{self.repository_url}/fedora/objects/#{self.pid}/datastreams/#{self.datastream_name}/content"
  end

end
