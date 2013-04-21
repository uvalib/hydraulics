require 'spec_helper'

describe Address do
  it { should belong_to(:addressable) }
  it { should validate_presence_of(:address_1).with_message(/is required./) }
  it { should validate_presence_of(:country).with_message(/is required./) }
  it { should validate_presence_of(:city).with_message(/is required./) }
  it { should allow_value("#{@address.city}").for(:city) }
  it { should allow_value("#{@address.phone}").for(:phone) }

  before do
    @address = FactoryGirl.build(:address)
  end
end
