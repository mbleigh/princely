require 'spec_helper'
require 'princely/version'

describe Princely::Version do
  let(:version) { '9.9.9' }
  before {
    allow(Princely::Version).to receive(:version).and_return(version)
  }

  it "prints the version" do
    expect(Princely::Version.to_s).to eql(version)
  end
end
