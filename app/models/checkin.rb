class Checkin < ActiveRecord::Base
  belongs_to :unit, :counter_cache => true
  belongs_to :admin_user

  validates :unit, :presence => {
              :if => 'self.unit_id', 
              :message => "association with this Unit is no longer valid because the Unit object no longer exists."
            }
  validates :admin_user, :presence => {
              :if => 'self.admin_user_id', 
              :message => "association with this User is no longer valid because the User object no longer exists."
            }   
end