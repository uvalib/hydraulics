class Request < Order
	# A Request is an Order that has not been approved for digitization. See Order.

  #------------------------------------------------------------------
  # validations
  #------------------------------------------------------------------
  validates :is_approved, :inclusion => { :in => [false] }

  #------------------------------------------------------------------
  # public class methods
  #------------------------------------------------------------------

  # Returns a string containing a brief, general description of this
  # class/model.
  def Request.class_description
    return 'A Request is an Order that has not been approved for digitization.'
  end

end
