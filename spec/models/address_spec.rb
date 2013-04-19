require 'spec_helper'

describe Address do
  it { should belong_to(:addressable) }
  it { should validate_presence_of(:address_1).with_message(/is required./) }
  it { should validate_presence_of(:country).with_message(/is required./) }
  it { should validate_presence_of(:city).with_message(/is required./) }
  it { should allow_value("#{@address.city}").for(:city) }
  it { should allow_value("#{@addres.phone}").for(:phone) }
  it { should allow_value("#{@address}").for(:first_name) }
  it { should allow_value("Lapin-Curley III Jr.").for(:last_name) }

  before do
    @address = FactoryGirl.build(:address)
  end
end
