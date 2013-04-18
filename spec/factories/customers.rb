# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :customer do
    first_name 'joe'
    last_name 'smith'
    email Faker::Internet.email
    association :academic_status

    factory :customer_with_primary_address do
      after(:create) {|object| FactoryGirl.create(:primary_address, addressable: object)}
    end
  end
end
