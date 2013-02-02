require 'spec_helper'
require 'princely/version'

describe Princely::Version do
  let(:version) { '9.9.9' }
  before {
    Princely::Version.stub(:version).and_return(version)
  }

  it "prints the version" do
    Princely::Version.to_s.should == version
  end
end
