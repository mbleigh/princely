require 'princely/pdf_helper'

module Princely
  class Railtie < Rails::Railtie
    initializer "princely.helper" do
      if Mime::Type.lookup_by_extension(:pdf) != 'application/pdf'
        Mime::Type.register 'application/pdf', :pdf
      end

      if ::Rails::VERSION::MAJOR >= 5
        ActiveSupport.on_load(:action_controller) do
          prepend Princely::PdfHelper
        end
      else
        ActiveSupport.on_load(:action_controller) do
          include Princely::PdfHelper
        end
      end
      if (::Rails::VERSION::MAJOR == 3 && ::Rails::VERSION::MINOR > 0) ||
        (::Rails::VERSION::MAJOR >= 4)
        ActiveSupport.on_load(:action_controller) do
          include Princely::AssetSupport
        end
      end
    end
  end
end
