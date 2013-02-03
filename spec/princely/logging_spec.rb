require 'spec_helper'
require 'princely/logging'

module Princely
  describe Logging do
    describe "filename=" do
      it "sets the log file" do
        Princely::Logging.filename = "palakir"
        Princely::Logging.filename.should == "palakir"
        Princely::Logging.filename = nil # clean up
      end
    end

    describe "logger=" do
      it "sets the logger" do
        Princely::Logging.logger = TestLogger
        Princely::Logging.logger.should == TestLogger
        Princely::Logging.logger = nil # clean up
      end
    end
  end
end
