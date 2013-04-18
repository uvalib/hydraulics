class Invoice < ActiveRecord::Base
  belongs_to :order, :counter_cache => true
  
  validates :order_id, :presence => true
  validates :order, :presence => {
    :message => "association with this Order is no longer valid because it does not exist."
  }

  delegate :date_order_approved, :date_customer_notified,
    :to => :order, :allow_nil => true, :prefix => true
end