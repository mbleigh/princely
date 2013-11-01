require 'spec_helper'

module Princely
  describe Executable do
    context 'without executable checks' do
      before do
        Princely::Executable.any_instance.stub(:check_for_executable)
      end

      describe '#join' do
        let(:path)       { '/some/path' }
        let(:executable) { Princely::Executable.new(path) }

        it 'joins an array of options' do
          expect(executable.join(['--opt', '--oopt'])).to eql("#{path} --opt --oopt")
        end

        it 'converts non-arrays to arrays' do
          expect(executable.join('--workworkwork')).to eql("#{path} --workworkwork")
        end
      end

      describe "executable_path" do
        it "returns a path for windows" do
          Princely.stub(:ruby_platform).and_return('mswin32')
          expect(Princely::Executable.new.path).to eql("C:/Program Files/Prince/Engine/bin/prince")
        end

        it "returns a path for OS X" do
          Princely.stub(:ruby_platform).and_return('x86_64-darwin12.0.0')
          expect(Princely::Executable.new.path).to eql(`which prince`.chomp)
        end
      end
    end

    describe "check_for_executable" do
      it "raises an error if path does not exist" do
        expect { Princely::Executable.new("/some/fake/path") }.to raise_error
      end

      it "raises an error if blank" do
        expect { Princely::Executable.new("") }.to raise_error
      end
    end

  end
end