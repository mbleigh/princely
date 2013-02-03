require 'spec_helper'

class TestLogger; end

describe Princely do
  describe "log_file=" do
    it "sets the log file" do
      Princely.log_file = "palakir"
      Princely.log_file.should == "palakir"
    end
  end

  describe "logger=" do
    it "sets the logger" do
      Princely.logger = TestLogger
      Princely.logger.should == TestLogger
    end
  end

  describe "find_prince_executable" do
    let(:prince) { Princely::PDF.new }

    it "returns a path for windows" do
      prince.stub(:ruby_platform).and_return('mswin32')
      prince.send(:find_prince_executable).should == "C:/Program Files/Prince/Engine/bin/prince"
    end

    it "returns a path for OS X" do
      prince.stub(:ruby_platform).and_return('x86_64-darwin12.0.0')
      prince.send(:find_prince_executable).should == `which prince`.chomp
    end
  end

end
