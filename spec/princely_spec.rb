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
    end

    it "defaults outside of Rails" do
      # Ensure Rails is not present for this test
      Object.send(:remove_const, :Rails) if defined?(Rails)

      File.stub(:dirname).and_return('outside_rails')
      prince = Princely.new
      prince.log_file.should == File.expand_path('outside_rails/log/prince.log')
    end
  end
end