require 'princely/pdf_helper'

if Mime::Type.lookup_by_extension(:pdf) != 'application/pdf'
  Mime::Type.register 'application/pdf', :pdf
end

ActionController::Base.send(:include, Princely::PdfHelper)
ActionController::Base.send(:include, Princely::AssetSupport) if Rails::VERSION::MINOR > 0
