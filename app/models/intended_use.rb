class IntendedUse < ActiveRecord::Base
  #------------------------------------------------------------------
  # relationships
  #------------------------------------------------------------------
  has_many :units
  
  #------------------------------------------------------------------
  # validations
  #------------------------------------------------------------------
  validates :description, :deliverable_format, :deliverable_resolution, :deloverable_resolution_unit, :presence => true

  #------------------------------------------------------------------
  # callbacks
  #------------------------------------------------------------------
  before_destroy :destroyable?

  before_save do
    # boolean fields cannot be NULL at database level
    self.is_internal_use_only = 0 if self.is_internal_use_only.nil?
    self.is_approved = 0          if self.is_approved.nil?
  end

  #------------------------------------------------------------------
  # public class methods
  #------------------------------------------------------------------
  # Returns a string containing a brief, general description of this
  # class/model.
  def IntendedUse.class_description
    return "Intended Use indicates how the Customer intends to use the digitized resource (Unit)."
  end

  # Returns a boolean value indicating whether it is safe to delete this record
  # from the database. Returns +false+ if this record has dependent records in
  # other tables, namely associated Unit records.
  #
  # This method is public but is also called as a +before_destroy+ callback.
  def destroyable?
    if not units.empty?
      return false
    end
    return true
  end

end
