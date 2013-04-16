require 'spec_helper'

describe Address do
  it { should belong_to(:addressable) } 
  it { should validate_presence_of(:address_1).with_message(/is required./) }
  it { should validate_presence_of(:country).with_message(/is required./) }
  it { should validate_presence_of(:city).with_message(/is required./) }
  it { should allow_value("Truth or Consequences").for(:city) }
  it { should allow_value("4345555555").for(:phone) }
  it { should allow_value("434.555.5555").for(:phone) }
  it { should allow_value("(434) 555-5555").for(:phone) }
  it { should allow_value("Mr. J. Max").for(:first_name) }
  it { should allow_value("Lapin-Curley III Jr.").for(:last_name) }

  before do 
    @customer = FactoryGirl.build(:address)
  end
end
