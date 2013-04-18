class LegacyIdentifier < ActiveRecord::Base
  has_and_belongs_to_many :bibls
  has_and_belongs_to_many :components
  has_and_belongs_to_many :master_files

  def destroyable?
    if self.master_files.empty? and self.components.empty? and self.bibls.empty?
      return true
    else
      return false
    end    
  end
end
