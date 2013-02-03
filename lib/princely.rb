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
  autoload :PDF,          'princely/pdf'

  class << self
    def logger
      @logger ||= defined?(Rails) ? Rails.logger : StdoutLogger
    end

    def log_file
      pathname = defined?(Rails) ? Rails.root : relative_pathname
      @log_file ||= pathname.join 'log', 'prince.log'
    end

    protected

    def relative_pathname
      Pathname.new(File.expand_path('../', __FILE__))
    end

  end
end
