require 'spec_helper'

module Princely
  describe AssetSupport do
    let(:dummy_class) { Class.new { include AssetSupport } }

    before(:context) do
      ENV['RAILS_ENV'] = 'production'
      load 'dummy/config/environment.rb'
    end

    after(:context) do
      ENV['RAILS_ENV'] = nil
      if Object.constants.include? :Rails
        Object.send(:remove_const, :Rails)
      end
    end

    specify "sprockets-rails behavior for production enviroment" do
      expect(Rails.application.assets).to be_nil
    end

    describe "#asset_file_path" do
      it "returns full asset path" do
        expect(dummy_class.new.asset_file_path("application.css").to_s)
          .to include "app/assets/stylesheets/application.css"
      end
    end
  end
end
