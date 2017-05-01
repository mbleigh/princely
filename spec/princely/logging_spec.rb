require 'spec_helper'
require 'princely/logging'

module Princely
  describe Logging do
    describe "filename=" do
      it "sets the log file" do
        Princely::Logging.filename = "palakir"
        expect(Princely::Logging.filename).to eql("palakir")
        Princely::Logging.filename = nil # clean up
      end
    end

    describe "logger=" do
      it "sets the logger" do
        Princely::Logging.logger = TestLogger
        expect(Princely::Logging.logger).to eql(TestLogger)
        Princely::Logging.logger = nil # clean up
      end
    end
  end
end
