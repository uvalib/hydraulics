class Request < Order
  validates :is_approved, :inclusion => { :in => [false] }
end