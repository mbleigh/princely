require 'spec_helper'

describe Princely do
  let(:html_doc) { "<html><body>Hello World</body></html>"}
  
  it "generates a PDF from HTML" do
    pdf = Princely.new.pdf_from_string html_doc
    pdf.should start_with("%PDF-1.4")
    pdf.rstrip.should end_with("%%EOF")
    pdf.length > 100
  end

  describe "executable" do
    it "raises an error if path does not exist" do
      expect { Princely.new(:path => "/some/fake/path") }.to raise_error
    end

    it "raises an error if blank" do
      expect { Princely.new(:path => "") }.to raise_error
    end
  end

  describe "logger" do
    it "defaults to STDOUT" do
      prince = Princely.new
      prince.logger.should == Princely::StdoutLogger
    end

    it "can be set" do
      LoggerClass = Class.new
      prince = Princely.new(:logger => LoggerClass.new)
      prince.logger.should be_an_instance_of LoggerClass
    end
  end

  describe "log_file" do
    it "defaults in Rails" do
      # Fake Rails for this test.
      Rails = double(:root => Pathname.new('in_rails'), :logger => nil)
      
      prince = Princely.new
      prince.log_file.to_s.should == 'in_rails/log/prince.log'

      # Unfake Rails
      Object.send(:remove_const, :Rails)
    end

    it "defaults outside of Rails" do
      File.stub(:dirname).and_return('outside_rails')
      prince = Princely.new
      prince.log_file.should == File.expand_path('outside_rails/log/prince.log')
    end
  end

  describe "exe_path" do
    let(:prince) { Princely.new }

    before(:each) do
      prince.stub(:log_file).and_return('/tmp/test_log')
      prince.exe_path = "/tmp/fake"
    end

    it "appends default options" do
      prince.exe_path.should == "/tmp/fake --input=html --server --log=/tmp/test_log "
    end

    it "adds stylesheet paths" do
      prince.style_sheets = " -s test.css "
      prince.exe_path.should == "/tmp/fake --input=html --server --log=/tmp/test_log  -s test.css "
    end

    it "adds arbitrary command line args" do
      prince.add_cmd_args "--fileroot=/some/root/path"

      prince.exe_path.should == "/tmp/fake --input=html --server --log=/tmp/test_log  --fileroot=/some/root/path "
    end
  end

  describe "find_prince_executable" do
    let(:prince) { Princely.new }

    it "returns a path for windows" do
      prince.stub(:ruby_platform).and_return('mswin32')
      prince.find_prince_executable.should == "C:/Program Files/Prince/Engine/bin/prince"
    end

    it "returns a path for OS X" do
      prince.stub(:ruby_platform).and_return('x86_64-darwin12.0.0')
      prince.find_prince_executable.should == `which prince`.chomp
    end
  end
end
