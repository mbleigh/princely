require 'princely/pdf_helper'

if Mime::Type.lookup_by_extension(:pdf) != 'application/pdf'
  Mime::Type.register 'application/pdf', :pdf
end

if defined?(Rails)
  if Rails::VERSION::MAJOR >= 5
    ActionController::Base.send(:prepend, Princely::PdfHelper)
    ActionController::Base.send(:include, Princely::AssetSupport)
  else
    ActionController::Base.send(:include, Princely::PdfHelper)
    ActionController::Base.send(:include, Princely::AssetSupport)    
  end
end