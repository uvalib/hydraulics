require 'spec_helper'

shared_examples_for Pidable do
  it { should have_many(:automation_messages) }
  it { should have_and_belong_to_many(:legacy_identifiers) }
  it { should belong_to(:availability_policy) }
  it { should belong_to(:indexing_scenario) }
  it { should belong_to(:use_right) }

  it "should return true for in_dl? if date_dl_ingest is set" do
    object = FactoryGirl.build(described_class.name.underscore.to_sym, date_dl_ingest: Time.now)
    object.in_dl?.should be_true
  end

  it "should return false for in_dl? if date_dl_ingest is not set" do
    object = FactoryGirl.build(described_class.name.underscore.to_sym, date_dl_ingest: nil)
    object.in_dl?.should be_false
  end
end

describe Bibl do
  it_behaves_like Pidable
end

describe Component do
  it_behaves_like Pidable
end

describe MasterFile do
  it_behaves_like Pidable
end
