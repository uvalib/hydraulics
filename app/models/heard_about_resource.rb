# == Schema Information
#
# Table name: heard_about_resources
#
#  id                   :integer         not null, primary key
#  description          :string(255)
#  is_approved          :boolean         default(FALSE), not null
#  is_internal_use_only :boolean         default(FALSE), not null
#  created_at           :datetime
#  updated_at           :datetime
#

class HeardAboutResource < ActiveRecord::Base

  #------------------------------------------------------------------
  # relationships
  #------------------------------------------------------------------
  has_many :units
 
  #------------------------------------------------------------------
  # validations
  #------------------------------------------------------------------
 
  #------------------------------------------------------------------
  # callbacks
  #------------------------------------------------------------------
  before_save do
    self.is_approved = 0 if self.is_approved.nil?
    self.is_internal_use_only = 0 if self.is_internal_use_only.nil?
  end
  
  #------------------------------------------------------------------
  # scopes
  #------------------------------------------------------------------
  scope :approved, where(:is_approved => true)
  scope :not_approved, where(:is_approved => false)
  scope :internal_use_only, where(:is_internal_use_only => true)
  scope :publicly_available, where(:is_internal_use_only => false)
 
  #------------------------------------------------------------------
  # public class methods
  #------------------------------------------------------------------
 
  #------------------------------------------------------------------
  # public instance methods
  #------------------------------------------------------------------

end