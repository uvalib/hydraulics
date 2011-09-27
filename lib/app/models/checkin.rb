class Checkin < ActiveRecord::Base

	#------------------------------------------------------------------
  # relationships
  #------------------------------------------------------------------
  belongs_to :unit, :counter_cache => true
  belongs_to :admin_user

  #------------------------------------------------------------------
  # validation
  #------------------------------------------------------------------
  validates :unit, :presence => {
              :if => 'self.unit_id', 
              :message => "association with this Unit is no longer valid because the Unit object no longer exists."
            }
  validates :admin_user, :presence => {
              :if => 'self.admin_user_id', 
              :message => "association with this User is no longer valid because the User object no longer exists."
            }   

  #------------------------------------------------------------------
  # public class methods
  #------------------------------------------------------------------

  # Returns a string containing a brief, general description of this
  # class/model.
  def Task.class_description
    return 'Task represents a task pertaining to a Unit and performed by a Staff Member using a Workstation.'
  end
end
