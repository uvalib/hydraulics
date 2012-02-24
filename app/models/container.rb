class Container < ActiveRecord::Base

  #------------------------------------------------------------------
  # relationships
  #------------------------------------------------------------------
  belongs_to :container_type
  has_and_belongs_to_many :components

  #------------------------------------------------------------------
  # validations
  #------------------------------------------------------------------
  validates :container_type_id, :label, :presence => true
  validates :container_type, :presence => {
    :messages => 'association with this ContainerType is no longer valid because it no longer exists.'
  }
  validates :parent_container_id, :presence => {
    :if => 'self.parent_container_id',
    :message => 'a parental association with this Container is no longer valid because it no longer exists.'
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
