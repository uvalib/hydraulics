class IndexingScenario < ActiveRecord::Base
  has_many :bibls
  has_many :components
  has_many :master_files
  has_many :units

  validates :name, :pid, :repository_url, :datastream_name, :presence => true
  validates :name, :pid, :uniqueness => true
  validates :repository_url, :format => {:with => URI::regexp(['http','https'])}

  def complete_url
    return "#{self.repository_url}/fedora/objects/#{self.pid}/datastreams/#{self.datastream_name}/content"
  end

end
