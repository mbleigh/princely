# PrinceXML Ruby interface.
# http://www.princexml.com
#
# Library by Subimage Interactive - http://www.subimage.com
#
#
# USAGE
# -----------------------------------------------------------------------------
#   princely = Princely.new
#   html_string = render_to_string(:template => 'some_document')
#   send_data(
#     princely.pdf_from_string(html_string),
#     :filename => 'some_document.pdf'
#     :type => 'application/pdf'
#   )
#
require 'logger'
require 'princely/rails' if defined?(Rails)

module Princely
  autoload :StdoutLogger, 'princely/stdout_logger'
  autoload :AssetSupport, 'princely/asset_support'
  autoload :Pdf,          'princely/pdf'
  autoload :Logging,      'princely/logging'
  autoload :Executable,   'princely/executable'

  class << self
    def executable
      @custom_executable || Princely::Executable.new
    end

    def executable=(custom_executable)
      @custom_executable = custom_executable
    end

    def root
      Pathname.new(File.expand_path('../', __FILE__))
    end

    def ruby_platform
      RUBY_PLATFORM
    end
  end
end
