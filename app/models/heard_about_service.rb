class HeardAboutService < ActiveRecord::Base

  #------------------------------------------------------------------
  # relationships
  #------------------------------------------------------------------
  has_many :customers

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
  # aliases
  #------------------------------------------------------------------
  # Necessary for Active Admin to poplulate pulldown menu
  alias_attribute :name, :description
 
  #------------------------------------------------------------------
  # public class methods
  #------------------------------------------------------------------
 
  #------------------------------------------------------------------
  # public instance methods
  #------------------------------------------------------------------

end

