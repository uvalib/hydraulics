require 'spec_helper'

describe Order do
  it "should be return true for active? if the order_status is ['requested', 'approved']" do
    ['requested', 'approved'].each {|value|
      FactoryGirl.build(:order, order_status: value).active?.should be_true
    }
  end

  it "should be return false for active? if the order_status is ['deferred', 'canceled']" do
    ['deferred', 'canceled'].each {|value|
      FactoryGirl.build(:order, order_status: value).active?.should be_false
    }
  end

  it "should return false for active? if order_status is anything else" do
    FactoryGirl.build(:order, order_status: Faker::Lorem.word).active?.should be_false
  end
end
