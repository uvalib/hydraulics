class Address < ActiveRecord::Base
  belongs_to :addressable, :polymorphic => true

  # validates :customer_id, :agency_id, :uniqueness => true
  validates :address_1, :country, :city, :presence => {
    :message => 'is required.'
  }
  validates :last_name, :first_name, :person_name_format => true, :allow_blank => true
  validates :city, :city_format => true, :allow_blank => true
  validates :phone, :phone_format => true, :allow_blank => true

end