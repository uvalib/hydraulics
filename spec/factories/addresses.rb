# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :address do
    address_1 Faker::Address.street_address
    address_2 Faker::Address.secondary_address
    post_code Faker::Address.zip
    city Faker::Address.city
    state Faker::Address.state
    country "United States"

    factory :primary_address do
      address_type 'primary'
      association :addressable
    end

    factory :billing_address do
      address_type 'billing'
      association :addressable
    end
  end
end
