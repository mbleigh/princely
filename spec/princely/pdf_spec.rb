require 'spec_helper'

describe Princely::Pdf do
  let(:html_doc) { "<html><body>Hello World</body></html>"}
  before(:each) do
    Princely.executable = nil
    allow_any_instance_of(Princely::Executable).to receive(:check_for_executable)
  end

  it "generates a PDF from HTML" do
    pdf = Princely::Pdf.new.pdf_from_string html_doc
    expect(pdf).to start_with("%PDF-1.4")
    expect(pdf.rstrip).to end_with("%%EOF")
    pdf.length > 100
  end

  describe "logger" do
    it "defaults to STDOUT" do
      prince = Princely::Pdf.new
      expect(prince.logger).to eql(Princely::StdoutLogger)
    end

    it "can be set" do
      LoggerClass = Class.new
      prince = Princely::Pdf.new(:logger => LoggerClass.new)
      expect(prince.logger).to be_an_instance_of(LoggerClass)
    end
  end

  describe "log_file" do
    it "defaults in Rails" do
      Princely::Logging.filename = nil
      # Fake Rails for this test.
      Rails = double(:root => Pathname.new('in_rails'), :logger => nil)

      prince = Princely::Pdf.new
      expect(prince.log_file.to_s).to eql('in_rails/log/prince.log')

      # Unfake Rails
      Object.send(:remove_const, :Rails)
    end

    it "defaults outside of Rails" do
      Princely::Logging.filename = nil

      outside_rails = Pathname.new('outside_rails')
      allow(Princely).to receive(:root).and_return(outside_rails)

      prince = Princely::Pdf.new
      expect(prince.log_file).to eql(outside_rails.join('log/prince.log'))
    end
  end

  describe "exe_path" do
    let(:prince) { Princely::Pdf.new(:path => '/tmp/fake') }

    before(:each) do
      allow(prince).to receive(:log_file).and_return('/tmp/test_log')
    end

    it "appends default options" do
      expect(prince.exe_path).to eql("/tmp/fake --input=html --server --log=/tmp/test_log ")
    end

    it "adds stylesheet paths" do
      prince.style_sheets = " -s test.css "
      expect(prince.exe_path).to eql("/tmp/fake --input=html --server --log=/tmp/test_log  -s test.css ")
    end

    it "adds the media type" do
      prince = Princely::Pdf.new(:path => '/tmp/fake', :media => "print_special")
      allow(prince).to receive(:log_file).and_return('/tmp/test_log')
      expect(prince.exe_path).to eql("/tmp/fake --input=html --server --log=/tmp/test_log --media=print_special ")
    end

    it "adds the javascript flag" do
      prince = Princely::Pdf.new(:path => '/tmp/fake', :javascript_flag => true)
      allow(prince).to receive(:log_file).and_return('/tmp/test_log')
      expect(prince.exe_path).to eql("/tmp/fake --input=html --server --log=/tmp/test_log --javascript ")
    end
  end
end
