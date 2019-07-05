require 'princely/pdf_helper'

if Mime::Type.lookup_by_extension(:pdf) != 'application/pdf'
  Mime::Type.register 'application/pdf', :pdf
end

if defined?(Rails)
  ActiveSupport.on_load(:action_controller) { include Princely::PdfHelper }
  ActiveSupport.on_load(:action_controller) { include Princely::AssetSupport }
end
