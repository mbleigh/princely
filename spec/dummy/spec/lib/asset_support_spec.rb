ENV['RAILS_ENV'] = 'production'
require 'rails_helper'

module Princely
  describe AssetSupport do
    let(:dummy_class) { Class.new { include AssetSupport } }

    after(:context) do
      ENV['RAILS_ENV'] = nil
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
